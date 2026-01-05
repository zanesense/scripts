import requests
import time
import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed

# ===== DEFAULT CONFIG =====
PROXY_FILE = "proxies.txt"
TIMEOUT = 5
THREADS = 30
TEST_URL = "http://httpbin.org/ip"
# =========================

def test_proxy(proxy):
    proxies = {
        "http": proxy,
        "https": proxy
    }

    start = time.time()
    try:
        r = requests.get(TEST_URL, proxies=proxies, timeout=TIMEOUT)
        latency = int((time.time() - start) * 1000)

        if r.status_code == 200:
            print(f"[ OK ] {proxy:<35} {latency} ms")
            return proxy
        else:
            print(f"[BAD] {proxy:<35} HTTP {r.status_code}")
            return None

    except Exception:
        print(f"[DEAD] {proxy}")
        return None


def to_proxychains(proxy):
    """
    Convert:
    socks5://1.2.3.4:1080
    → socks5 1.2.3.4 1080
    """
    proto, rest = proxy.split("://")
    ip, port = rest.split(":")
    return f"{proto} {ip} {port}"


def main():
    parser = argparse.ArgumentParser(description="Fast proxy tester & cleaner")
    parser.add_argument(
        "--proxychains",
        action="store_true",
        help="Write output in proxychains format"
    )
    parser.add_argument(
        "-f", "--file",
        default=PROXY_FILE,
        help="Proxy file (default: proxies.txt)"
    )

    args = parser.parse_args()
    proxy_file = args.file

    with open(proxy_file, "r") as f:
        proxies = [
            line.strip()
            for line in f
            if line.strip() and not line.startswith("#")
        ]

    print(f"\n[*] Testing {len(proxies)} proxies...\n")

    working = []

    with ThreadPoolExecutor(max_workers=THREADS) as executor:
        futures = {executor.submit(test_proxy, p): p for p in proxies}

        for future in as_completed(futures):
            result = future.result()
            if result:
                working.append(result)

    # Write output
    with open(proxy_file, "w") as f:
        if args.proxychains:
            f.write("# ProxyChains format\n")
            f.write("[ProxyList]\n")
            for proxy in working:
                f.write(to_proxychains(proxy) + "\n")
        else:
            for proxy in working:
                f.write(proxy + "\n")

    print("\n==============================")
    print(f"[✓] Working proxies saved : {len(working)}")
    print(f"[✗] Removed dead proxies : {len(proxies) - len(working)}")
    print(f"[i] Output format        : {'proxychains' if args.proxychains else 'original'}")
    print("==============================\n")


if __name__ == "__main__":
    main()

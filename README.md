This batch script allows you to **apply or revert network performance tweaks** on Windows. It modifies TCP settings and MTU values for active network interfaces.

---

## How to Use

1. **Download** the script file `run.bat`.
2. **Right-click** the file and select **Run as Administrator**.
3. **Choose an option** from the menu:
   * `1` → Apply network tweaks
   * `2` → Revert network tweaks to defaults
   * `3` → Exit
4. **Wait** for the script to complete. It will display messages for each change.
5. **Press any key** to return to the menu or exit.

---

## Notes

* MTU changes are applied to **all connected network interfaces**.
* Running without Administrator privileges may **fail** for some commands.
* Use the revert option if you want to **reset all settings** to default.

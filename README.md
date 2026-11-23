# xone-control

A lightweight Linux desktop manager and background idle auto-shutoff daemon for **Xbox Wireless Controllers** — supporting both **Xbox Wireless Adapters** (via [`xone`](https://github.com/dlundqvist/xone)) and **Bluetooth** (`xpadneo` or stock Linux BlueZ HID).

> [!IMPORTANT]
> **Driver note:**
> - **Xbox Wireless Adapter (USB dongle):** Requires the [`xone`](https://github.com/dlundqvist/xone) Linux kernel driver (`xone-dongle` + `xone-gip-gamepad`) already installed. This is a companion app and does not include the driver itself.
> - **Bluetooth:** Works out of the box with `bluez` (`bluetoothctl`) using either `xpadneo` or the stock Linux Bluetooth driver. *(Note: Xbox Guide LED brightness/mode and dongle pairing are hardware-limited to the `xone` USB dongle.)*

## Features

| Feature | `xone` Wireless Dongle | Bluetooth (`xpadneo` / stock) |
| --- | :---: | :---: |
| Automatic idle auto-shutoff / disconnect | Yes | Yes |
| Stick-drift deadzone filtering | Yes | Yes |
| Live color-coded battery percentage badge | Yes (4-step) | Yes (exact %) |
| One-click Turn Off / Disconnect Now | Yes | Yes |
| Multi-controller live cards | Yes | Yes |
| Xbox Guide button LED brightness (`0–50`) & mode | Yes | No (BT HID limit) |
| One-click 60s dongle pairing mode | Yes | N/A |
| Controller firmware version display | Yes* | No |

*\*Firmware version display requires a `xone` build that exposes `firmware_version` in sysfs (e.g. PR #231).*

- **Zero-Bloat Background Service:** Close the GUI anytime — `xone-control.service` runs quietly in the background (~2 MB RAM) to enforce your idle timeout and LED settings.

## Requirements

- Python 3 + `PySide6` (`python-pyside6` on Arch/CachyOS, `python3-pyside6` on Fedora/Debian/Ubuntu)
- **For USB dongle users:** [`xone`](https://github.com/dlundqvist/xone) driver + your user in the `input` group (`sudo usermod -aG input $USER`, then log out/in)
- **For Bluetooth users:** `bluez-utils` (`bluetoothctl`) + your user in the `input` group (so the daemon can read `/dev/input/event*`)

## Installation

```bash
git clone https://github.com/Zach9113/xone-control.git
cd xone-control
./install.sh
```

The installer:
1. Installs `xone-control` and `xone-control-daemon` to `~/.local/bin/`
2. Installs the desktop launcher (`Xbox Wireless Controller Manager`)
3. Installs the udev permissions rule (`/etc/udev/rules.d/99-xone-user-permissions.rules`) so `input` group members can write to `xone` sysfs controls without `sudo`
4. Enables and starts the `xone-control.service` systemd user daemon

## Uninstall

```bash
./uninstall.sh
```

## Configuration

Settings are saved automatically in `~/.config/xone-control/config.json`:

```json
{
  "idle_enabled": true,
  "idle_timeout_minutes": 15,
  "led_brightness": 20,
  "led_mode": 1
}
```

## Notes on Battery Percentage

- **Over `xone` wireless dongle:** Microsoft's GIP protocol reports battery state as a 2-bit stepped level (`Low`, `Normal`, `High`, `Full`) rather than an exact 0–100 integer. `xone-control` maps those 4 hardware steps to `~20%` (red), `~50%` (yellow), `~75%` (green), and `100%` (green).
- **Over Bluetooth:** Displays the percentage reported by the kernel HID battery service (`capacity`) directly, with the same color thresholds (`>=65%` green, `30–64%` yellow, `<30%` red).

## License

GPL-3.0-or-later

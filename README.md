# xone-control

A lightweight Linux desktop manager and background idle auto-shutoff daemon for **Xbox Wireless Adapters** running the [`xone`](https://github.com/dlundqvist/xone) kernel driver.

> [!IMPORTANT]
> **Requires the [`xone`](https://github.com/dlundqvist/xone) Linux kernel driver.**
> This is a companion app — it does **not** include the driver itself, and it will **not** work with Bluetooth (`xpadneo`) or wired-only `xpad`. You must already have `xone` (`xone-dongle` + `xone-gip-gamepad`) installed and working with your Xbox Wireless Adapter.

## Features

- **Automatic Idle Power-Off:** Monitors controller input (`/dev/input/event*` with stick-drift deadzone filtering) and automatically powers off inactive controllers via `xone`'s sysfs interface after a configurable timeout (default: 15 minutes).
- **Xbox Guide Button LED Control:** Adjust LED brightness (`0–50`) and LED mode (`Off`, `Solid On`, `Fast Blink`, `Slow Blink`, `Breathing / Pulse`) in real time, and automatically re-apply your preferred setting whenever a controller connects.
- **One-Click Dongle Pairing & Power Off:** Put your Xbox Wireless Adapter into 60-second pairing mode or power off controllers straight from your desktop without reaching behind your PC.
- **Live Status & Multi-Controller Support:** Displays connected controller slots, color-coded battery percentage badges (`100%` / `~75%` / `~50%` / `~20%`), firmware version (when supported by `xone`), and live idle countdown timers.
- **Zero-Bloat Background Service:** Close the GUI anytime — `xone-control.service` runs quietly in the background (~2 MB RAM) to enforce your idle timeout and LED settings.

## Requirements

- Linux with the [`xone`](https://github.com/dlundqvist/xone) driver (`xone-dongle` + `xone-gip-gamepad`)
- Python 3 + `PySide6` (`python-pyside6` on Arch/CachyOS, `python3-pyside6` on Fedora/Debian/Ubuntu)
- Your user must be in the `input` group (`sudo usermod -aG input $USER`, then log out and back in)

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

Over Microsoft's wireless GIP protocol, Xbox controllers report battery state as a 2-bit stepped level (`Low`, `Normal`, `High`, `Full`) rather than an exact 0–100 integer. `xone-control` maps those 4 hardware steps to `~20%` (red), `~50%` (yellow), `~75%` (green), and `100%` (green).

## License

GPL-3.0-or-later

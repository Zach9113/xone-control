#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing xone-control binaries to ~/.local/bin..."
install -Dm755 "$SCRIPT_DIR/bin/xone-control" "$HOME/.local/bin/xone-control"
install -Dm755 "$SCRIPT_DIR/bin/xone-control-daemon" "$HOME/.local/bin/xone-control-daemon"

echo "==> Installing desktop entry and systemd user service..."
install -Dm644 "$SCRIPT_DIR/desktop/xone-control.desktop" "$HOME/.local/share/applications/xone-control.desktop"
install -Dm644 "$SCRIPT_DIR/systemd/xone-control.service" "$HOME/.config/systemd/user/xone-control.service"

echo "==> Installing udev permissions rule (requires sudo)..."
sudo install -Dm644 "$SCRIPT_DIR/udev/99-xone-user-permissions.rules" /etc/udev/rules.d/99-xone-user-permissions.rules
sudo udevadm control --reload-rules

# Apply permissions immediately to any already-connected dongle or controller
sudo sh -c '
for f in /sys/bus/usb/drivers/xone-dongle/*:1.0/pairing \
         /sys/bus/usb/drivers/xone-dongle/*:1.0/poweroff \
         /sys/class/leds/gip*:white:status/brightness \
         /sys/class/leds/gip*:white:status/mode; do
    [ -e "$f" ] && chgrp input "$f" && chmod 0664 "$f"
done
'

if ! id -nG "$USER" | grep -qw input; then
    echo
    echo "NOTE: Your user ($USER) is not in the 'input' group yet."
    echo "Run the following and log out/in so the daemon can control your dongle without sudo:"
    echo "  sudo usermod -aG input $USER"
fi

echo "==> Enabling and starting xone-control.service..."
systemctl --user daemon-reload
systemctl --user enable --now xone-control.service
systemctl --user restart xone-control.service

echo
echo "Done! Launch 'Xbox Wireless Controller Manager' from your app menu or run: xone-control"

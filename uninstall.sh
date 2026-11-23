#!/usr/bin/env bash
set -euo pipefail

echo "==> Stopping and disabling xone-control.service..."
systemctl --user disable --now xone-control.service 2>/dev/null || true

echo "==> Removing user files..."
rm -f "$HOME/.local/bin/xone-control"
rm -f "$HOME/.local/bin/xone-control-daemon"
rm -f "$HOME/.local/share/applications/xone-control.desktop"
rm -f "$HOME/.config/systemd/user/xone-control.service"
systemctl --user daemon-reload

if [ -f /etc/udev/rules.d/99-xone-user-permissions.rules ]; then
    echo "==> Removing udev rule (requires sudo)..."
    sudo rm -f /etc/udev/rules.d/99-xone-user-permissions.rules
    sudo udevadm control --reload-rules
fi

echo "Done! Saved settings in ~/.config/xone-control/ were left intact (remove manually if desired)."

#!/usr/bin/env bash
# Constrói uma ISO bootável (Debian Live) que liga direto no WebOS, em tela cheia.
# Rode num Debian/Ubuntu (ou WSL com Debian/Ubuntu), com internet:   sudo bash construir-iso.sh
set -euo pipefail
[ "$(id -u)" = 0 ] || { echo "Rode com sudo:  sudo bash construir-iso.sh"; exit 1; }
AQUI="$(cd "$(dirname "$0")" && pwd)"
apt-get update && apt-get install -y live-build debootstrap xorriso squashfs-tools
W=/tmp/webos-iso-build; rm -rf "$W"; mkdir -p "$W"; cd "$W"

lb config --distribution bookworm --architectures amd64 --binary-images iso-hybrid \
  --debian-installer none --apt-recommends false --iso-volume "WebOS" --iso-application "WebOS" \
  --bootappend-live "boot=live components quiet splash locales=pt_BR.UTF-8 keyboard-layouts=br timezone=America/Sao_Paulo" \
  --archive-areas "main contrib non-free-firmware"

mkdir -p config/package-lists config/includes.chroot/opt/webos config/includes.chroot/etc/skel config/includes.chroot/etc/systemd/system/getty@tty1.service.d
cat > config/package-lists/webos.list.chroot <<'L'
xserver-xorg xserver-xorg-legacy xinit openbox x11-xserver-utils dbus-x11 dbus-user-session libpam-systemd sudo chromium chromium-l10n fonts-dejavu fonts-liberation fonts-noto-color-emoji
network-manager network-manager-gnome alsa-utils pulseaudio firmware-linux-free firmware-iwlwifi firmware-realtek
live-boot live-config systemd-sysv locales console-setup
L
install -m 755 "$AQUI/bos" config/includes.chroot/opt/webos/bos

# login automático no console 1 e início do X
cat > config/includes.chroot/etc/systemd/system/getty@tty1.service.d/autologin.conf <<'L'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin user --noclear %I $TERM
L
cat > config/includes.chroot/etc/skel/.bash_profile <<'L'
if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]; then exec startx; fi
L
cat > config/includes.chroot/etc/skel/.xinitrc <<'L'
xset s off -dpms 2>/dev/null
openbox-session &
export BOS_POWEROFF=1 WEBOS_DIR="$HOME/.bos" WEBOS_EXTRA_ARGS="--disable-gpu|--disable-dev-shm-usage"
while true; do
  /opt/webos/bos
  [ $? -eq 42 ] && break   # 42 = o usuario escolheu Desligar
  sleep 1
done
L
lb build
cp -v live-image-amd64.hybrid.iso "$AQUI/WebOS.iso"
echo; echo "Pronto: $AQUI/WebOS.iso"

#!/bin/bash
set -e

echo "=== INICIANDO POST-INSTALACIÓN DE ARCH LINUX (ENTORNO TUI / HYPRLAND) POR CH3x ==="

# 1. Actualizar el sistema base
echo "[+] Actualizando el sistema..."
sudo pacman -Syu --noconfirm

# 2. Instalar Paru (AUR Helper) si no está instalado
if ! command -v paru &> /dev/null; then
    echo "[+] Instalando Paru (AUR Helper)..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ..
    rm -rf paru
fi

# 3. Instalar todos tus programas y herramientas (Oficiales y AUR)
echo "[+] Instalando entorno, utilidades y aplicaciones..."
paru -S --noconfirm \
    hyprland kitty waybar hyprpaper ttf-jetbrains-mono-nerd noto-fonts \
    noto-fonts-emoji less xdg-user-dirs hyprpolkitagent xdg-desktop-portal-hyprland \
    pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber \
    brightnessctl playerctl 7zip unzip gzip unrar yazi ffmpeg jq poppler \
    fd ripgrep fzf zoxide resvg imagemagick tree-sitter-cli nodejs npm \
    wl-clipboard bluez bluez-utils bluetui bat eza man-db man-pages \
    man-pages-es impala btop wiremix trash-cli walker elephant-all \
    hypridle hyprlock udisks2 udiskie

# 4. Habilitar y arrancar servicios esenciales
echo "[+] Habilitando servicios de systemd..."
sudo systemctl enable --now bluetooth.service

# 5. Configuración de servicios de usuario (Wayland / Pipewire / Elephant)
echo "[+] Configurando servicios de usuario..."
systemctl --user start elephant.service || true
systemctl --user enable --now elephant.service || true
systemctl --user enable --now pipewire pipewire-pulse wireplumber

echo "======================================================"
echo "[+] ¡POST-INSTALACIÓN COMPLETADA CON ÉXITO!"
echo "[+] Tu entorno TUI y Hyprland están listos."
echo "======================================================"

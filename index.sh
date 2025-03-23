#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root!"
    exit 1
fi

# Fix mirrorlist errors
sed -i 's/^erver/Server/g' /etc/pacman.d/mirrorlist

# Remove conflicting neofetch version
pacman -R --noconfirm neofetch-git 2>/dev/null

# Install required packages
pacman -S --noconfirm neofetch curl feh plasma-desktop kdeplasma-addons || { echo "Package installation failed"; exit 1; }

# Set custom background
BG_URL="https://abinot.ir/file/images/d_bg_abinot.jpg"
BG_PATH="/usr/share/wallpapers/abinot_wallpaper.jpg"
curl -L --retry 3 --retry-delay 5 "$BG_URL" -o "$BG_PATH" || { echo "Failed to download wallpaper"; exit 1; }

# User-specific configuration
sudo -u $SUDO_USER bash <<'EOF'
export $(dbus-launch)

# KDE Plasma configuration
if [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
    kwriteconfig5 --file "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" \
        --group Containments --group 1 --group Wallpaper --group org.kde.image --group General \
        --key Image "file:///usr/share/wallpapers/abinot_wallpaper.jpg"
    plasmashell --replace &
elif [ -n "$DISPLAY" ]; then
    feh --bg-scale "/usr/share/wallpapers/abinot_wallpaper.jpg"
fi
EOF

# Change hostname
NEW_HOSTNAME="Abinot-OS"
hostnamectl set-hostname "$NEW_HOSTNAME"
echo "$NEW_HOSTNAME" > /etc/hostname
sed -i "s/127.0.1.1.*/127.0.1.1\t$NEW_HOSTNAME/" /etc/hosts

# Neofetch configuration
mkdir -p /etc/neofetch
cat > /etc/neofetch/config.conf <<'EOF'
print_info() {
    info title
    info underline
    
    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "Resolution" resolution
    info "DE" de
    info "WM" wm
    info "WM Theme" wm_theme
    info "Theme" theme
    info "Icons" icons
    info "Terminal" term
    info "Terminal Font" term_font
    info "CPU" cpu
    info "GPU" gpu
    info "Memory" memory
    
    info cols
}

print_ascii on
ascii_distro="abinot_os"

# Custom ASCII art
abinot_os() {
    cat <<'EOM'
${c1}          ████████████████████          
      ██████▀░░░░░░░░▀▀██████      
    ████▀░░░░░░░░░░░░░░░░▀████    
  ███▀░░░░░░░░░░░░░░░░░░░░░░▀███  
  ██░░░░░░░░░░░░░░░░░░░░░░░░░░██  
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
███░░░░░░░░░░░░░░░░░░░░░░░░░███  
  ███▄░░░░░░░░░░░░░░░░░░░░░▄███    
    ████▄▄░░░░░░░░░░░░░░▄▄████      
      ███████▄▄▄▄▄▄▄▄████████        
          ████████████████████        
EOM
}

title_fqdn=off
kernel_shorthand=on
distro_shorthand=on
EOF

# OS identification
cat > /etc/os-release <<EOF
NAME="Abinot OS"
PRETTY_NAME="Abinot OS Ultimate Edition"
ID=abinot
ID_LIKE=arch
ANSI_COLOR="0;36"
HOME_URL="https://abinot.ir/"
SUPPORT_URL="https://abinot.ir/support"
BUG_REPORT_URL="https://abinot.ir/bugs"
LOGO=abinot-logo
EOF

echo "تمامی تغییرات با موفقیت اعمال شد!"
echo "برای اعمال کامل تغییرات:"
echo "1. از سیستم خارج شده و مجدد وارد شوید"
echo "2. دستور neofetch را اجرا کنید"
echo "3. در صورت نیاز سیستم را ریاستارت کنید"

#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root!"
    exit 1
fi

# Enable required packages
pacman -S --noconfirm neofetch curl feh plasma-desktop kdeplasma-addons 

# Set custom background
BG_URL="https://abinot.ir/file/images/d_bg_abinot.jpg"
BG_PATH="/usr/share/wallpapers/abinot_wallpaper.jpg"
curl -L "$BG_URL" -o "$BG_PATH" || { echo "Failed to download wallpaper"; exit 1; }

# Set background for KDE Plasma
if [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
    kwriteconfig5 --file "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" \
        --group Containments --group 1 --group Wallpaper --group org.kde.image --group General \
        --key Image "file://$BG_PATH"
    plasmashell --replace &
elif [ -n "$DISPLAY" ]; then
    feh --bg-scale "$BG_PATH"
fi

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

# Download and set OS logo
LOGO_URL="https://abinot.ir/file/images/abinot-logo.png"
LOGO_PATH="/usr/share/pixmaps/abinot-logo.png"
curl -L "$LOGO_URL" -o "$LOGO_PATH" || { echo "Failed to download logo"; exit 1; }

# Modify OS information
cat > /etc/os-release <<EOF
NAME="Abinot"
PRETTY_NAME="Abinot"
ID=abinot
ID_LIKE=arch
ANSI_COLOR="0;36"
HOME_URL="https://abinot.ir/"
SUPPORT_URL="https://abinot.ir/support"
BUG_REPORT_URL="https://abinot.ir/support"
LOGO=abinot-logo
EOF

echo "Modifications complete!"
echo "You may need to:"
echo "1. Log out and back in for changes to take effect"
echo "2. Run 'neofetch' to see the new configuration"
echo "3. Reboot to apply all changes system-wide"

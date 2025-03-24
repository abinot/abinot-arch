#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root! Run:"
    echo "  sudo abinot"
    exit 1
fi

# Configuration variables
LOGO_URL="https://www.abinot.ir/file/images/abinot-logo.png"
LOGO_PATH="/usr/share/abinot-logo.png"
CLEAN_HOSTNAME="Abinot"  # باید با حروف کوچک باشد

# Remove conflicting neofetch version
pacman -R --noconfirm neofetch-git 2>/dev/null

# Install required packages
pacman -S --needed --noconfirm neofetch curl w3m || {
    echo "Package installation failed"
    exit 1
}

# Download and install logo
curl -L --retry 3 --retry-delay 5 "$LOGO_URL" -o "$LOGO_PATH" || {
    echo "Failed to download logo"
    exit 1
}

# Set hostname properly
hostnamectl set-hostname "$CLEAN_HOSTNAME"
sed -i "/127.0.1.1/c\127.0.1.1\t$CLEAN_HOSTNAME" /etc/hosts

# System identification files
cat > /etc/os-release <<EOF
NAME="Abinot"
PRETTY_NAME="Abinot Foundation Edition"
ID=abinot
ID_LIKE=arch
ANSI_COLOR="36;1"
HOME_URL="https://abinot.ir/"
SUPPORT_URL="https://abinot.ir/support"
BUG_REPORT_URL="https://abinot.ir/support"
LOGO=abinot-logo
EOF

# LSB release config
cat > /etc/lsb-release <<EOF
DISTRIB_ID=Abinot
DISTRIB_RELEASE="1.0.0"
DISTRIB_DESCRIPTION="Abinot Foundation Edition"
DISTRIB_CODENAME=persia  # باید به انگلیسی باشد
EOF

# Neofetch advanced configuration
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
    info "DE" de
    info "WM" wm
    info "Theme" theme
    info "Icons" icons
    info "Terminal" term
    info "CPU" cpu
    info "GPU" gpu
    info "Memory" memory
    
    info cols
}

# ASCII Art Settings
print_ascii on
ascii_distro="abinot_os"
ascii_colors=(6 6 6 6 6 6)
ascii_bold=on

# Custom ASCII Art
abinot_os() {
    cat <<'EOM'
\033[36m
          ████████████████████          
      ██████▀░░░░░░░░▀▀██████      
    ████▀░░░░░░░░░░░░░░░░▀████    
  ███▀░░░░░░░░░░░░░░░░░░░░░░▀███  
  ██░░░░░░░░░░░░░░░░░░░░░░░░░░██  
██░░░░▄▄▄▄▄▄▄░░░░░░░░▄▄▄▄▄▄▄░░░░██
██░░▐████▀████▄░░░▄████▀████▌░░██
██░░░░▀▀▀▄▀▀▀███▄███▀▀▀▄▀▀▀░░░░██
███░░░░░░▄█████▌▐█████▄░░░░░░███  
  ███▄░░░░▀▀▀▀▀░░▀▀▀▀▀░░░░▄███    
    ████▄▄░░░░░░░░░░░░░░▄▄████      
      ███████▄▄▄▄▄▄▄▄████████        
          ████████████████████\033[0m
EOM
}

# Image Settings (for GUI terminals)
image_source="ascii"
# image_source="$LOGO_PATH"
# image_size="300px"

title_fqdn=off
kernel_shorthand=on
distro_shorthand=off
EOF

# Apply changes
kbuildsycoca5 2>/dev/null
systemctl daemon-reload

echo -e "\n\033[1;32mSuccess!\033[0m Reboot and run 'neofetch' to see changes."

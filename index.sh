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
pacman -S --noconfirm neofetch curl || { echo "Package installation failed"; exit 1; }

# Change hostname and related settings
NEW_HOSTNAME="Abinot"
CLEAN_HOSTNAME="Abinot"

# Set hostname
hostnamectl set-hostname "$NEW_HOSTNAME"

# Update hosts file
sed -i "/127.0.1.1/c\127.0.1.1\t$CLEAN_HOSTNAME" /etc/hosts

# Update hostname in pam files
sed -i "s/ab@asus-tuf-f15-/ab@$CLEAN_HOSTNAME/" /etc/pam.d/* 2>/dev/null

# System-wide OS identification
cat > /etc/os-release <<EOF
NAME="$CLEAN_HOSTNAME"
PRETTY_NAME="$CLEAN_HOSTNAME Ultimate Edition"
ID=abinot
ID_LIKE=arch
ANSI_COLOR="0;36"
HOME_URL="https://abinot.ir/"
SUPPORT_URL="https://abinot.ir/support"
BUG_REPORT_URL="https://abinot.ir/support"
LOGO=abinot-logo
EOF

# Create additional identification files
echo "$CLEAN_HOSTNAME" > /etc/issue
echo "$CLEAN_HOSTNAME" > /etc/issue.net
cat > /etc/lsb-release <<EOF
DISTRIB_ID=$CLEAN_HOSTNAME
DISTRIB_RELEASE="24.1"
DISTRIB_DESCRIPTION="$CLEAN_HOSTNAME"
DISTRIB_CODENAME=persian
EOF

# Neofetch configuration
mkdir -p /etc/neofetch
cat > /etc/neofetch/config.conf <<'EOF'
print_info() {
    info underline
    prin "$(color 6)███▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀███"
    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "Resolution" resolution
    info "DE" de
    info "WM" wm
    info "Terminal" term
    info "CPU" cpu
    info "GPU" gpu
    info "Memory" memory
    prin "$(color 6)███▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄███"
}

distro="$CLEAN_HOSTNAME"
ascii_distro="$CLEAN_HOSTNAME"

print_ascii on
ascii_colors=(6 6 6 6 6 6)
ascii_bold=on

$CLEAN_HOSTNAME() {
    cat <<'EOM'
${c6}          ████████████████████          
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
          ████████████████████        
EOM
}

title_fqdn=off
kernel_shorthand=on
distro_shorthand=off
EOF

# Force refresh system info
kbuildsycoca5 2>/dev/null
systemctl daemon-reload

echo "
تمامی تغییرات با موفقیت اعمال شد!
"

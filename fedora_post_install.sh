#!/bin/bash

# https://docs.fedoraproject.org/en-US/quick-docs

set -e

timedatectl set-local-rtc 1 --adjust-system-clock

# install fish
dnf install fish
fish
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install jorgebucaran/nvm.fish
fisher install IlanCosman/tide@v5
chsh -s /usr/bin/fish

# add flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.sublimetext.three
flatpak install flathub org.telegram.desktop
flatpak install flathub com.discordapp.Discord
flatpak install flathub com.slack.Slack
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux
flatpak install flathub md.obsidian.Obsidian
flatpak install flathub com.visualstudio.code
flatpak install flathub com.spotify.Client

# install base packages
dnf install git fastfetch helix cairo swaybg waybar mako xdg-desktop-portal-gtk xdg-desktop-portal-gnome \
  fuzzel alacritty nasm llvm clang-tools-extra 

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer

# install niri
mkdir -p dev/external/
cd dev/external/
git clone https://github.com/YaLTeR/niri
cd niri
cargo build --release
# add niri to sddm login manager
cp target/release/niri 	/usr/bin/
cp resources/niri-session 	/usr/bin/
cp resources/niri.desktop 	/usr/share/wayland-sessions/
cp resources/niri-portals.conf 	/usr/share/xdg-desktop-portal/
cp resources/niri.service 	/usr/lib/systemd/user/
cp resources/niri-shutdown.target 	/usr/lib/systemd/user/

# install virt-manager
dnf install @virtualization
systemctl start libvirtd 
systemctl enable libvirtd 
usermod -a -G libvirt $(whoami)

# for ssh
set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK

# in case 'fastfetch' did not show up with the nvidia graphic card name
# install nvidia drivers
# enable repo 'RPM Fusion for Fedora 40 - Nonfree - NVIDIA Driver'
# dnf install kernel-headers kernel-devel xorg-x11-drv-nvidia.x86_64 xorg-x11-drv-nvidia-libs.x86_64 akmod-nvidia.x86_64
# akmods --force
# dracut --force
# reboot

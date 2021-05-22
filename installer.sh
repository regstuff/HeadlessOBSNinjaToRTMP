#!/bin/bash
# From - https://www.tweaking4all.com/software/linux-software/use-xrdp-remote-access-ubuntu-14-04/

# Adding generic kernel modules to GCP for alsa - https://askubuntu.com/a/1226822
# If ls /lib/modules/$(uname -r)/kernel/sound/drivers doesn't list the snd-aloop.ko then try the following command to installed the additional modules:
# Comment these two lines the second time you run, after the first reboot
sudo apt install linux-modules-extra-$(uname -r)
sudo reboot

# Get latest xrdp version
sudo add-apt-repository ppa:hermlnx/xrdp
sudo apt-get update
sudo apt-get install xrdp

# Minimal desktop environment
sudo apt-get install xfce4

# Install XFCE4 terminal (way better than xterm)
sudo apt-get install xfce4-terminal

# Install icon sets
sudo apt-get install gnome-icon-theme-full tango-icon-theme

# Point rdp session to xfce4 desktop environment
echo xfce4-session >~/.xsession

# Set password for root login in Desktop
sudo passwd root

# Run on boot
systemctl enable xrdp

# Start it up
systemctl start xrdp

# Install Chrome if needed - https://cloud.google.com/architecture/chrome-desktop-remote-on-compute-engine
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg --install google-chrome-stable_current_amd64.deb
sudo apt install --assume-yes --fix-broken

# Install/Start PulseAudio - https://askubuntu.com/questions/28176/how-do-i-run-pulseaudio-in-a-headless-server-installation
# First add kernel modules to GCP for alsa - https://askubuntu.com/a/1226822
# If ls /lib/modules/$(uname -r)/kernel/sound/drivers doesn't list the snd-aloop.ko then try the following command to installed the additional modules:
sudo apt install linux-modules-extra-$(uname -r)
sudo reboot

# Set Group Memberships for PulseAudio - Change user from root to something else if required, or run PulseAudio systemwide - https://askubuntu.com/a/939338/3940
sudo usermod -aG pulse,pulse-access root

# If PulseAudio is configured for root (or do su -l for other user)
sudo -i

# Start PulseAudio (for non-root users)
pulseaudio -D

# Install Puppeteer dependencies
sudo apt-get install gconf-service libasound2 libatk1.0-0 libatk-bridge2.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgconf2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils

# Update npm to latest otherwise Puppeteer won't install
sudo npm install -g npm@latest

# Install Puppeteer
sudo npm i puppeteer

# Install Virtual Cam
# Installing & number of devices - https://stackoverflow.com/questions/31859459/how-can-i-pass-a-fake-media-stream-to-firefox-from-command-line/63312430#63312430
sudo apt install v4l2loopback-dkms
sudo modprobe v4l2loopback devices=1 card_label="My Fake Webcam"

# If needed compilation for latest version to avoid bugs - https://askubuntu.com/questions/881305/is-there-any-way-ffmpeg-send-video-to-dev-video0-on-ubuntu
# Info on setting video_nr (what is it?) - https://stackoverflow.com/a/31515111/3016570
# Generic info - Virtual camera info at - https://github.com/umlaeute/v4l2loopback 

# Activate ALSA - https://www.onetransistor.eu/2017/10/virtual-audio-cable-in-linux-ubuntu.html
# Install alsautils to list devices
# List devices - https://superuser.com/questions/462309/list-all-alsa-devices
sudo apt-get install alsa-utils

# Compile FFMPEG with --enable-libpulse. Not part of this script.

# Below is in case ALSA loopback is required
# Start loopback module
sudo modprobe snd-aloop
# sudo modprobe -r snd-aloop (to remove) - https://www.tecmint.com/load-and-unload-kernel-modules-in-linux/
# Set number of subdevices - https://alsa.opensrc.org/Jack_and_Loopback_device_as_Alsa-to-Jack_bridge
# Edit/create /etc/modprobe.d/sound.conf & add below two lines (uncommented) and change pcm_substreams (default is 8)
#alias snd-card-0 snd-aloop
#options snd-aloop index=0 pcm_substreams=1

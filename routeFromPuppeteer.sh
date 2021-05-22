#!/bin/bash
# Push id is set to stimulus in OBS Ninja. Change as needed.

# For individual login. 
#pulseaudio -D

# For sudo - starts pulse audio in system mode
screen -dmS pulse bash -c "pulseaudio --system";
# Wait for pulse audio to load up
sleep 5;

# Load a vistual speaker and associated virtual mic
sudo pactl load-module module-null-sink sink_name=vspeaker sink_properties=device.description=virtual_speaker
sudo pactl load-module module-remap-source master=vspeaker.monitor source_name=vmic source_properties=device.description=virtual_mic

# Run Puppeteer and open OBS Ninja view link. Chromium outputs to default sink i.e. virtual speaker
# html folder is owned by username (otherwise virtual sink module may not load? Check once)
screen -dmS chrome bash -c "node obsninja-browse.js";

# Run FFMPEG to take virtual mic as input and output to rtmp 
# FFMPEG should be compiled with enable-libpulse
# With video from stream1 and audio mix from stream1 and stream2 - 2 second delay (Note: ajoin filter does not work. See https://stackoverflow.com/a/37821130/3016570 about amerge)
# Using -f alsa instead of -f pulse as per https://bbs.archlinux.org/viewtopic.php?pid=1804547#p1804547 
screen -dmS tortmp bash -c "PULSE_SOURCE=vmic /home/sravanth_valluru/ffmpeg_build/bin/ffmpeg -f alsa -i pulse -i rtmp://127.0.0.1/distribute/stream1 -filter_complex "[0:a][1:a]amerge=inputs=2[a]" -map "[a]" -acodec aac -ac 2 -b:a 128k -map 1:v -vcodec copy -f flv rtmp://127.0.0.1/distribute/stream2";

# Audio only
#screen -dmS tortmp bash -c "PULSE_SOURCE=vmic /home/sravanth_valluru/ffmpeg_build/bin/ffmpeg -f alsa -i pulse -f flv rtmp://127.0.0.1/distribute/stream2";

# Get volume of pulse audio vspeaker
parec --raw --channels=1 --latency=2 2>/dev/null | od -N2 -td2 | head -n1 | cut -d' ' -f2- | tr -d ' '
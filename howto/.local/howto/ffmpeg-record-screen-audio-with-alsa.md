How To: record screen with audio (loopback) using ffmpeg
========================================================

+ add snd-aloop to modules:

	sudo modprobe snd-aloop pcm_substreams=1

+ edit /etc/asound.conf to record loopback (this will disable audio output):

	echo 'pcm.!default { type plug slave.pcm "hw:Loopback,0,0" }' >> \
	/etc/asound.conf

+ alternatively) "record audio from an application while alsa routing the audio 
to an output device: https://trac.ffmpeg.org/wiki/Capture/ALSA

+ start the actual recording. (The example above will record a 1280x1080 
portion of the screen 0.0 from the coordinates 0,0 using the ALSA audio 
hardware 'Loopback,1,0'):

	ffmpeg -video_size 1280x1080 -framerate 25 -f x11grab -i :0.0+0,0 -f alsa \
	-ac 2 -ar 44100 -i hw:Loopback,1,0 output.mkv

+ when done, remove the line from /etc/asound.conf to once again enable audio 
output.

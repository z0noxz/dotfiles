#!/bin/sh

case "$1" in
cpu)
	echo "$(cut -f1 /tmp/.tmstat)%"
	;;
mem)
	echo "$(cut -f2 /tmp/.tmstat)%"
	;;
battery)
	_PATH="/sys/class/power_supply/BAT0"
	_STATUS="$(cat "$_PATH/status")"
	_FULL="$(cat "$_PATH/energy_full")"
	_NOW="$(cat "$_PATH/energy_now")"

	[ "$_STATUS" = "Discharging" ] && _STATUS="-" || _STATUS="+"
	echo "$_STATUS$((100 * _NOW / _FULL))%"
	;;
temp)
	_TEMP="$(sensors | awk '/Core\ 0/ {gsub(/\+/,"",$3); gsub(/\..+/,"",$3); print $3}')"

	echo "$_TEMP°c"
	;;
pkg)
	echo "$([ -f /tmp/.xbps.queue ] && cat /tmp/.xbps.queue || echo 0)•"
esac

#!/bin/sh

case "$1" in
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
esac

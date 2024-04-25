#!/usr/bin/env bash
QTILE_LAYOUT="monadtall"
QTILE_GROUPS=("WWW4" "WWW5" "6" "7" "8" "9")

if [ "$1" = "home" ]; then
    MODEBUILTIN="1920x1080"
    MODE1="3840x2160 --rate 30.00"
    MODE2="3840x2160 --rate 30.00"
    POS1="0x1195 --rotate normal"
    POS2="3840x0 --rotate right"
    POSB="6000x1900 --rotate normal"
    QTILE_LAYOUT="monadwide"
elif [ "$1" = "work" ]; then
    MODEBUILTIN="1920x1080"
    MODE1="3840x2160 --rate 30.00"
    MODE2="2560x1440"
    POS1="0x0 --rotate normal"
    POS2="3840x720 --rotate normal"
    POSB="6400x1080 --rotate normal"
else
    echo "Invalid argument. Usage: $0 home|work"
    exit 1
fi

# Find the names of the DP-X-1 and DP-X-2 displays
DP_NUM=1
while [ "$DP_NUM" -le 10 ]; do
    DP_NAMES=$(xrandr | grep "DP${DP_NUM}-[1-9]" | awk '{print $1}')
    DP1_NAME=""
    DP2_NAME=""
    for DP_NAME in $DP_NAMES; do
        DP_MODES=$(xrandr | grep -A 1 "$DP_NAME" | grep "^[[:space:]]*[0-9]*x[0-9]*")
        if [ "$DP_MODES" != "" ]; then
            if [ "$DP1_NAME" == "" ]; then
                DP1_NAME="$DP_NAME"
            elif [ "$DP2_NAME" == "" ]; then
                DP2_NAME="$DP_NAME"
            fi
        fi
    done

    if [ "$DP1_NAME" != "" ] && [ "$DP2_NAME" != "" ]; then
        echo "Found displays: $DP1_NAME, $DP2_NAME"
        break
    fi

    DP_NUM=$((DP_NUM+1))
done

# Use the correct display names in the rest of the script
if [ "$DP1_NAME" != "" ] && [ "$DP2_NAME" != "" ]; then
    xrandr --output eDP1 --primary --mode ${MODEBUILTIN} \
           --output ${DP1_NAME} --off \
           --output ${DP2_NAME} --off

    xrandr --output eDP1 --primary --mode ${MODEBUILTIN} --pos ${POSB} \
           --output ${DP1_NAME} --mode ${MODE1} \
           --output ${DP2_NAME} --off

    xrandr --output eDP1 --primary --mode ${MODEBUILTIN} --pos ${POSB} \
           --output ${DP1_NAME} --mode ${MODE1} --pos ${POS1} \
           --output ${DP2_NAME} --mode ${MODE2} --pos ${POS2}
else
    echo "Could not find DP-X-1 and DP-X-2 displays"
    xrandr --auto
fi

echo "Reloading Qtile"
qtile cmd-obj -o cmd -f reload_config
if [ "$QTILE_LAYOUT" != "monadtall" ]; then
    for group in "${QTILE_GROUPS[@]}"; do
        eval "qtile cmd-obj -o group '$group' -f setlayout -a '$QTILE_LAYOUT'"
    done
fi

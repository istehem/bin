#!/bin/bash

SCREEN_NAME=mpv
ATTACHED="Attached"
VIDEO_DIR=$HOME/video

if ! screen -ls | grep -q "$SCREEN_NAME"; then
    # create screen mpv in detached mode
    screen -S $SCREEN_NAME -dm bash
    screen -S $SCREEN_NAME -X stuff "cd $VIDEO_DIR^M"
    screen -S $SCREEN_NAME -X stuff 'DISPLAY=:0 mpv '
fi

if [ "$1" == "-e" ]; then
    # ^U erease line in bash
    screen -S $SCREEN_NAME -X stuff "^UDISPLAY=:0 mpv $2^M"
    exit 0
fi

if [ "$1" == "-q" ]; then
    # send quit
    screen -S $SCREEN_NAME -X stuff "q"
    exit 0
fi

if [ "$1" == "-p" ]; then
    # send play/pause
    screen -S $SCREEN_NAME -X stuff "p"
    exit 0
fi

if [ "$1" == "-d" ]; then
    # dont try to attach; stop here!
    exit 0
fi

if ! screen -ls | grep -q -oP "$SCREEN_NAME.*$ATTACHED"; then
    screen -rd $SCREEN_NAME
else
    echo "screen $SCREEN_NAME already attached"
    exit 0
fi

#!/bin/bash
IMAGES_DIR=/home/root/customization/images

POWEROFF_IMAGES_DIR=$IMAGES_DIR/poweroff
POWEROFF_FILE=/usr/share/remarkable/poweroff.original.png
if [ -d $POWEROFF_IMAGES_DIR ]; then
    POWEROFF_IMAGES_COUNT=$(ls $POWEROFF_IMAGES_DIR | wc -l)
    if [ $POWEROFF_IMAGES_COUNT -ne 0 ]; then
        POWEROFF_FILE=$(shuf -n1 -e $POWEROFF_IMAGES_DIR/*)
    fi;
fi
cp $POWEROFF_FILE /usr/share/remarkable/poweroff.png

SUSPENDED_IMAGES_DIR=$IMAGES_DIR/suspended
SUSPENDED_FILE=/usr/share/remarkable/suspended.original.png
if [ -d $SUSPENDED_IMAGES_DIR ]; then
    SUSPENDED_IMAGES_COUNT=$(ls $SUSPENDED_IMAGES_DIR | wc -l)
    if [ $SUSPENDED_IMAGES_COUNT -ne 0 ]; then
        SUSPENDED_FILE=$(shuf -n1 -e $SUSPENDED_IMAGES_DIR/*)
    fi;
fi
cp $SUSPENDED_FILE /usr/share/remarkable/suspended.png

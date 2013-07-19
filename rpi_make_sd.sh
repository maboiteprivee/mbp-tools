#!/bin/bash
# Copyright 2013 Alexandre Bulté <alexandre[at]bulte[dot]net>
# 
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

EXPECTED_ARGS=2

NAME=$1
IMAGE="$2"

if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0` <partition_name> <image_path>"
    echo "Example: `basename $0` disk2s1 ./rpi.img"
    exit $E_BADARGS
fi
echo

echo "You're probably trying to use this disk:"
df -h | grep $NAME
echo
echo

DISK_NAME="r"${NAME:0:5}

echo "Confirm you want to unmount /dev/$1 and erase /dev/$DISK_NAME by typing 'Yes, sir'"
read confirmation

if [ "$confirmation" != 'Yes, sir' ]
then
    echo "Abort!"
    exit 0
fi

echo
echo "sudo diskutil unmount /dev/$NAME"
sudo diskutil unmount /dev/$NAME
echo

if [ ! -f "$2" ]
then
    echo "File $2 does not exist."
    exit 0
fi

echo "sudo dd bs=1m if="$2" of=/dev/$DISK_NAME"
echo "Please wait, might take a long time..."
sudo dd bs=1m if="$2" of=/dev/$DISK_NAME
echo 
echo "sudo diskutil eject /dev/$DISK_NAME"
sudo diskutil eject /dev/$DISK_NAME
echo
echo "Well done my friend \o/ Cheers."
exit 0

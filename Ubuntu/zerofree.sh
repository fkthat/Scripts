#!/bin/sh

$fs = /dev/sda2

systemctl stop systemd-journald.* && \
    sudo swapoff -a && \
    mount -n -o remount,ro $fs && \
    zerofree -v $fs

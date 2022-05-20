#!/bin/sh

systemctl stop systemd-journald* && \
    sudo swapoff -a && \
    mount -n -o remount,ro / && \
    zerofree -v /dev/sda2

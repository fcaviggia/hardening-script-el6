#!/bin/sh

# Set the default to Runlevel 3 (No XWindows)
        sed -i 's/id:5:initdefault:/id:3:initdefault:/' /etc/inittab


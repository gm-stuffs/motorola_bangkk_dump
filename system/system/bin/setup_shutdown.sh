#!/system/bin/sh
#
# Copyright (c) 2016, Motorola LLC  All rights reserved.
#
# Shutdown phone if setup screen is active while phone appears to be in a box.
#

# Bail-out conditions:  Setup-check has already run once and saw the device
# wasn't running setup, or the boot mode isn't normal.

if [ -e /data/misc/.nosetupcheck ] || [ -e /data/misc/setupcheck/.nosetupcheck ]; then
    exit
fi

BOOTMODE=`getprop ro.bootmode`

if [ $BOOTMODE != "normal" ]; then
    exit
fi

# Wait 60 minutes, or until Setup Wizard is complete.

while true; do
    echo wait for 60 minutes of uptime.
    UPTIME=($(</proc/uptime))
    UPTIME=${UPTIME%%.*}
    if [ $UPTIME -gt 3600 ]; then
       echo done
       break
    fi

    # check the value of user_setup_complete of user0
    ACTIVITY=`dumpsys settings | grep user_setup_complete | head -n 1`
    WIZARD_UP=`echo $ACTIVITY | grep -c value:0`

    # If Setup Wizard is complete, then set nosetupcheck, and exit
    if [ ! -z "$ACTIVITY" ] && [ $WIZARD_UP -eq 0 ]; then
        echo Disabling setup_shutdown for future boots.
        echo 1 > /data/misc/setupcheck/.nosetupcheck
        exit
    fi

    sleep 1
done

# Waited 60 minutes, and Setup Wizard is still running.  If the screen
# is off, then assume the devices is unattended and shut down.
SCREEN_OFF=`dumpsys power | grep -c "PowerManagerService.Display: ref count=0"`

if [ $SCREEN_OFF -gt 0 ]; then
    echo Setup Wizard is up and the screen is off -- Shutdown
    setprop sys.powerctl shutdown,setup
fi

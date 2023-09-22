#!/system/bin/sh
#
# Copyright (c) 2013-2020, Motorola LLC  All rights reserved.
#

SCRIPT=${0#/system/bin/}

# function: print log into kmsg
kmsg_print() {
	echo "$SCRIPT: $1" > /dev/kmsg
}
# if ufs fw need config , please add the ufs info to CONFIG_FILE
CONFIG_FN="/vendor/etc/ufs_ffu.conf"
VENDOR=`cat /sys/block/sda/device/vendor | tr -d ' '`
MODEL=`cat /sys/block/sda/device/model | tr -d ' '`
REV=`cat /sys/block/sda/device/rev`

kmsg_print "Vendor: $VENDOR"
kmsg_print "Model: $MODEL"
kmsg_print "Revision: $REV"

if [ -f $CONFIG_FN ]; then
	eval $(awk '{ if ($2 == "'$MODEL'" && $1 == "'$VENDOR'" && $3 == "'$REV'" ) {print "FW_FILE="$4;}}' $CONFIG_FN)
else
	kmsg_print "the UFS does not need upgrade, exit..."
	exit 0
fi

if [ -z $FW_FILE ] ; then
	kmsg_print "firmware is up to date, exit..."
	exit 0
else
	kmsg_print "FW_FILE: $FW_FILE"
fi

if [ "$VENDOR" == "SAMSUNG" ] && [ -x /system_ext/bin/sg_write_buffer ]; then
	kmsg_print "SAMSUNG firmware upgrade tool supported."
elif [ "$VENDOR" == "SKhynix" ] && [ -x /system_ext/bin/sg_write_buffer ]; then
	kmsg_print "SKhynix firmware upgrade tool supported."
elif [ "$VENDOR" == "MICRON" ] && [ -x /system_ext/bin/usc_wtbuf ]; then
	kmsg_print "MICRON firmware upgrade tool supported."
elif [ "$VENDOR" == "KIOXIA" ] && [ -x /system_ext/bin/ufs-tool ] ; then
	kmsg_print "KIOXIA firmware upgrade tool supported."
else
	kmsg_print "firmware upgrade tool not supported, exit..."
	exit 0
fi

if [ -f $FW_FILE ] ; then
	kmsg_print "firmware file $FW_FILE found, upgrade now..."
else
	kmsg_print "failed to find firmware file $FW_FILE, exit..."
	exit 1
fi

sync

# Flash the firmware
if [ "$VENDOR" == "MICRON" ] ; then
	/system_ext/bin/usc_wtbuf do_ffu $FW_FILE /dev/block/sda > /dev/kmsg 2>&1
elif [ "$VENDOR" == "KIOXIA" ] ; then
	/system_ext/bin/ufs-tool ffu -t 0 -w $FW_FILE -p /dev/sg3 -g 1 > /dev/kmsg 2>&1
elif [ "$VENDOR" == "SAMSUNG" ] ; then
    /system_ext/bin/sg_write_buffer -v -m dmc_offs_defer -b 524288 -I $FW_FILE  /dev/block/sda > /dev/kmsg 2>&1
else
    kmsg_print "unknown the ufs device , just exit"
	exit 1
fi

if [ $? -eq "0" ];then
	kmsg_print "upgrade done successfully, reboot now..."
	sleep 1
	echo b >/proc/sysrq-trigger
	exit 0
fi

kmsg_print "failed to upgrade!"

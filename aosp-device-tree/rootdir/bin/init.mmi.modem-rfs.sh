#!/vendor/bin/sh

echo "Retrieve Modem RFS logs"

__copy_logs()
{
    file1="${1}"
    file2="${2}"

    if [ ! -f "${file1}" ]; then
        echo -e "${file1} invalid"
        return
    fi

    /vendor/bin/chmod 666 "${file1}"
    /vendor/bin/cp "${file1}" "${file2}"
    /vendor/bin/chmod 640 "${file2}"
}

mdm_rfs_folder=/mnt/vendor/persist/rfs/msm/mpss
mdm_rfs_log0=modem_efs_log_0.txt
mdm_rfs_log1=modem_efs_log_1.txt
mdm_rfs_buf_log=mot_efs_buffered_log.txt

mdm_log_target_folder=/data/vendor/dontpanic

if [ -z "$1" ]
then
    loop=0
else
    loop=1
fi

while true
do
    /vendor/bin/echo "1" > /data/vendor/radio/read_modem_efs
    /vendor/bin/sleep 1
    /vendor/bin/echo "0" > /data/vendor/radio/read_modem_efs

    __copy_logs $mdm_rfs_folder/$mdm_rfs_log0 $mdm_log_target_folder/$mdm_rfs_log0
    __copy_logs $mdm_rfs_folder/$mdm_rfs_log1 $mdm_log_target_folder/$mdm_rfs_log1
    __copy_logs $mdm_rfs_folder/$mdm_rfs_buf_log $mdm_log_target_folder/$mdm_rfs_buf_log

    if [ $loop -eq 1 ]
    then
        /vendor/bin/sleep 600
    else
        break
    fi
done

exit 0






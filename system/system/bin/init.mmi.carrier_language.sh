#!/system/bin/sh

# Copyright (c) 2021, Motorola Mobility LLC, All Rights Reserved.
#
# Date Created: 08/11/2021, FEATURE-7101 - Set first boot language based on channel id
#
PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

boot_carrier=`getprop ro.boot.carrier`

set_carrier_init_language ()
{
    case $boot_carrier in
        3gb|eegb|o2gb|retgb|tescogb|retie|vfgb|tescoie|3ie|demogb )
            setprop persist.sys.locale en-GB
        ;;
        amxbr|niibr|oibr|retbr|tefbr|timbr )
            setprop persist.sys.locale pt-BR
        ;;
        altpt )
            setprop persist.sys.locale pt-PT
        ;;
        3ie|retie|tescoie )
            setprop persist.sys.locale en-IE
        ;;
        airin|amzin|jioin|retin|retjio )
            setprop persist.sys.locale en-IN
        ;;
        bouyfr|retfr|vffr|orafr|altfr )
            setprop persist.sys.locale fr-FR
        ;;
        altmx|amxar|amxcl|amxco|amxla|amxmx|amxpe|amxpr|attmx|avaco|entcl|iusmx|niicl|niimx|niipe|opencl|openla|openmx|openpe|perar|retar|retcl|retla|retla1st|retmx|retpe|tefar|tefcl|tefco|tefla|tefmx|tefpe|tefunl|tigca|tigca1st|tigco|womcl )
            setprop persist.sys.locale es-US
        ;;
        retca|bwaca|tkpca|rcica|wndca )
            setprop persist.sys.locale en-CA
        ;;
        cmcc|ctcn|cucn|retcn )
            setprop persist.sys.locale zh-Hans-CN
        ;;
        dtpl|playpl|pluspl )
            setprop persist.sys.locale pl-PL
        ;;
        gt4gtw )
            setprop persist.sys.locale zh-Hant-TW
        ;;
        mobilpk )
            setprop persist.sys.locale ur-PK
        ;;
        o2de|retde|vfde )
            setprop persist.sys.locale de-DE
        ;;
        retes|tefes|yoigo|oraes|vfes )
            setprop persist.sys.locale es-ES
        ;;
        retid )
            setprop persist.sys.locale in-ID
        ;;
        retjp|softbank|ymobile )
            setprop persist.sys.locale ja-JP
        ;;
        retma )
            setprop persist.sys.locale ar-MA
        ;;
        retmm )
            setprop persist.sys.locale my-MM
        ;;
        retru )
            setprop persist.sys.locale ru-RU
        ;;
        retth|trueth )
            setprop persist.sys.locale th-TH
        ;;
        smarthk )
            setprop persist.sys.locale zh-Hant-HK
        ;;
        telhu|vfhu )
            setprop persist.sys.locale hu-HU
        ;;
        telstra|vfau )
            setprop persist.sys.locale en-AU
        ;;
        timit|windit|vfit )
            setprop persist.sys.locale it-IT
        ;;
        vfro )
            setprop persist.sys.locale ro-RO
        ;;
    esac
}

# The main code
set_carrier_init_language
return 0

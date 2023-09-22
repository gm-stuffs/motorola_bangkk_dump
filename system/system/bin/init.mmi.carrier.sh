#!/system/bin/sh

# Copyright (c) 2017, Motorola Mobility LLC, All Rights Reserved.
#
# Date Created: 11/01/2017, Carrier Client ID matrix for Android 20170915
#
PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

while getopts iosde op;
do
   case $op in
           i)  init_early_property=1;;
           o)  post_property_overlay=1;;
           s)  post_sprint_property=1;;
           d)  boot_complete_operation=1;;
           e)  demo_mode_operation=1;;
   esac
done
shift $((OPTIND-1))

# carrier and wave always set on early time (early than early-init)
carrier=`getprop ro.carrier`
boot_carrier=`getprop ro.boot.carrier`
wave=`getprop ro.mot.product_wave`
wave_y=${wave:0:4}
wave_q=${wave:5:1}
carrierid=`getprop persist.carrier.carrierid`
sprintclientid=`getprop persist.carrier.google.searchid`
omadm_operator=`getprop persist.omadm.operator.numeric`
gms_premier_tier=`getprop ro.product.gms_premier_tier`

# return success if product wave is at least target year/quarter
# parameter: target (YYYY.Q)
is_wave_at_least()
{
    target_y=${1:0:4}
    target_q=${1:5:1}
    if [ $wave_y -eq $target_y ]; then
        [[ $wave_q -ge $target_q ]]
    else
        [[ $wave_y -gt $target_y ]]
    fi
    return
}


# Set Google GMS clientid properties -- early-init
set_google_clientid_properties ()
{
    # Set default build properties to configure client ID values for GMS on Android
    setprop ro.mot.gms.clientidbase android-motorola

    # Set client ID properties base on region carrier
    case $carrier in
        # North America Region - Amazon
        amz )
            setprop ro.mot.gms.clientidbase.ms android-motorola
            setprop ro.mot.gms.clientidbase.am android-motorola
        ;;
        # North America Region - AT&T
        att|attpre )
            setprop ro.mot.gms.clientidbase.am android-att-us
            if is_wave_at_least 2021.3 ; then
                setprop ro.mot.gms.clientidbase.ms android-att-us-rvc3
                setprop ro.mot.gms.clientidbase.pg android-att-inca
            else
                setprop ro.mot.gms.clientidbase.ms android-att-us-revc
            fi
        ;;
        # North America Region - AT&T (AIO prepaid)
        aio )
            setprop ro.mot.gms.clientidbase.ms android-att-aio-us
            setprop ro.mot.gms.clientidbase.am android-att-aio-us
        ;;
        # North America Region - Spectrum
        spectrum )
            if is_wave_at_least 2022.3 ; then
                setprop ro.mot.gms.clientidbase.ms android-charter-us-rvc3
                setprop ro.mot.gms.clientidbase.vs android-charter-us-rvc3
                setprop ro.mot.gms.clientidbase.pg android-charter-inca
            else
                setprop ro.mot.gms.clientidbase.ms android-charter-us-revc
            fi
        ;;
        # North America Region - Comcast
        comcast )
            if is_wave_at_least 2022.1 ; then
                setprop ro.mot.gms.clientidbase.ms android-comcast-us-rvc3
                setprop ro.mot.gms.clientidbase.vs android-comcast-us-rvc3
                setprop ro.mot.gms.clientidbase.pg android-comcast-inca
            else
                setprop ro.mot.gms.clientidbase.ms android-comcast-us-revc
            fi
        ;;
        # North America Region - Cricket
        cricket )
            setprop ro.mot.gms.clientidbase.am android-cricket
            if is_wave_at_least 2021.3 ; then
                setprop ro.mot.gms.clientidbase.ms android-cricket-us-rvc3
                setprop ro.mot.gms.clientidbase.pg android-cricket-inca
            else
                setprop ro.mot.gms.clientidbase.ms android-cricket-us-revc
            fi
        ;;
        # North America Region - Google Project Fi
        fi )
            setprop ro.mot.gms.clientidbase.ms android-fi
        ;;
        # North America Region - Sprint
        sprint )
            # Set sprint alone
        ;;
        # North America Region - Boost
        boost )
            if is_wave_at_least 2021.3 ; then
                if is_wave_at_least 2022.1 ; then
                    setprop ro.mot.gms.clientidbase.ms android-dish-us-rvc3
                    setprop ro.mot.gms.clientidbase.vs android-dish-us-rvc3
                else
                    setprop ro.mot.gms.clientidbase.ms android-boostdish-us-revc
                fi
            else
                setprop ro.mot.gms.clientidbase.ms android-boost-us-revc
            fi
        ;;
        # North America Region - TMO
        tmo )
            if is_wave_at_least 2022.1 ; then
                setprop ro.mot.gms.clientidbase.ms android-tmus-us-rvc3
                setprop ro.mot.gms.clientidbase.vs android-tmus-us-rvc3
                setprop ro.mot.gms.clientidbase.pg android-tmus-inca
            else
                setprop ro.mot.gms.clientidbase.ms android-tmus-us-revc
            fi
        ;;
        # North America Region - USC
        usc )
            if is_wave_at_least 2022.1 ; then
                setprop ro.mot.gms.clientidbase.ms android-uscellular-us-rvc3
                setprop ro.mot.gms.clientidbase.vs android-uscellular-us-rvc3
                setprop ro.mot.gms.clientidbase.pg android-uscellular-inca
            else
                setprop ro.mot.gms.clientidbase.am android-uscellular-us
                setprop ro.mot.gms.clientidbase.ms android-uscellular-us-revc
            fi
        ;;
        # North America Region - Verizon
        vzw|vzwpre )
            setprop ro.mot.gms.clientidbase.am android-verizon
            if is_wave_at_least 2021.3 ; then
                setprop ro.mot.gms.clientidbase.ms android-verizon-us-rvc3
                setprop ro.mot.gms.clientidbase.pg android-verizon-inca
            else
                setprop ro.mot.gms.clientidbase.ms android-verizon
            fi
        ;;
        # North America Region - Tracfone
        tracfone )
            if is_wave_at_least 2021.3 ; then
                setprop ro.mot.gms.clientidbase.ms android-tracfone-us-rvc3
                setprop ro.mot.gms.clientidbase.vs android-tracfone-us-rvc3
                setprop ro.mot.gms.clientidbase.am android-tracfone-us
                setprop ro.mot.gms.clientidbase.pg android-tracfone-inca
            else
                setprop ro.mot.gms.clientidbase.ms android-americamovil-{country}-revc
                setprop ro.mot.gms.clientidbase.am android-americamovil-{country}
            fi
        ;;
        # North America Region - Metropcs
        metropcs )
            setprop ro.mot.gms.clientidbase.ms android-mpcs-us-revc
        ;;
        # North America Region - Fido / Rogers Canada
        rcica )
            setprop ro.mot.gms.clientidbase.ms android-rogers-ca-revc
        ;;
        # North America Region - Bell Canada
        bwaca )
            setprop ro.mot.gms.clientidbase.ms android-bell-ca-revc
        ;;
        # EMEA - eegb
        eegb )
            if is_wave_at_least 2022.1 ; then
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.ms android-ee-uk-rvc3
                else
                    setprop ro.mot.gms.clientidbase.ms android-ee-uk-rvc2
                    setprop ro.mot.gms.clientidbase.vs android-ee-uk-rvc2
                fi
                setprop ro.mot.gms.clientidbase.cr android-motorola
            else
                if is_wave_at_least 2021.3 ; then
                    if [ $gms_premier_tier == true ]; then
                        setprop ro.mot.gms.clientidbase.ms android-ee-uk-rvc3
                    else
                        setprop ro.mot.gms.clientidbase.ms android-ee-uk-rvc2
                    fi
                else
                    setprop ro.mot.gms.clientidbase.ms android-ee-uk-revc
                fi
            fi
        ;;
        # EMEA - oraeu orafr oraes
        oraes|oraeu|orafr )
            if is_wave_at_least 2021.3 ; then
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.ms android-orange-{country}-rvc3
                else
                    setprop ro.mot.gms.clientidbase.ms android-orange-{country}-rvc2
                fi
                setprop ro.mot.gms.clientidbase.am android-orange-{country}
                setprop ro.mot.gms.clientidbase.cr android-motorola
            else
                setprop ro.mot.gms.clientidbase.ms android-orange-{country}-revc
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.pg android-orange-gtmp
                fi
            fi
        ;;
        # EMEA - dteu, tmde
        dteu|tmde )
            if is_wave_at_least 2021.3 ; then
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.ms android-dt-{country}-rvc3
                    setprop ro.mot.gms.clientidbase.am android-tmobile-{country}
                else
                    setprop ro.mot.gms.clientidbase.ms android-dt-{country}-rvc2
                    setprop ro.mot.gms.clientidbase.am android-tmobile-{country}
                fi
                setprop ro.mot.gms.clientidbase.cr android-motorola
            else
                setprop ro.mot.gms.clientidbase.ms android-dt-{country}-revc
                setprop ro.mot.gms.clientidbase.am android-tmobile-{country}
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.pg android-dt-gtmp
                fi
            fi
        ;;
        # EMEA Vodafone - vfeu
        vfeu )

            if is_wave_at_least 2021.3 ; then
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.ms android-vf-{country}-rvc3
                else
                    setprop ro.mot.gms.clientidbase.ms android-vf-{country}-rvc2
                fi
                setprop ro.mot.gms.clientidbase.am android-vf-{country}
                setprop ro.mot.gms.clientidbase.cr android-motorola
            else
                setprop ro.mot.gms.clientidbase.ms android-vf-{country}-revc
                if [ $gms_premier_tier == true ]; then
                    if [ ! is_wave_at_least 2021.3 ]; then
                        setprop ro.mot.gms.clientidbase.pg android-vf-gtmp
                    fi
                fi
            fi
        ;;
        # EMEA Telefonica - tefes, o2gb, o2de
        tefes|o2gb|o2de )
            setprop ro.mot.gms.clientidbase.am android-tef-{country}
            if is_wave_at_least 2022.2 ; then
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.vs android-tef-{country}-rvc3
                fi
            fi
            if is_wave_at_least 2021.3 ; then
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.ms android-tef-{country}-rvc3
                else
                    setprop ro.mot.gms.clientidbase.ms android-tef-{country}-rvc2
                fi
                setprop ro.mot.gms.clientidbase.cr android-motorola
            else
                if is_wave_at_least 2020.2 ; then
                    setprop ro.mot.gms.clientidbase.ms android-tef-{country}-revc
                else
                    setprop ro.mot.gms.clientidbase.ms android-motorola-rev2
                fi
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.pg android-tef-gtmp
                fi
            fi
        ;;
        # America Movil - Claro, Comcel, Telcel, Porta
        amovil|amxar|amxbr|amxcl|amxco|amxla|amxmx|amxpe|openmx )
            if is_wave_at_least 2023.1 ; then
                if [ $gms_premier_tier == true ] ; then
                    setprop ro.mot.gms.clientidbase.ms android-americamovil-{country}-rvc3
                    setprop ro.mot.gms.clientidbase.vs android-americamovil-{country}-rvc3
                else
                    setprop ro.mot.gms.clientidbase.ms android-americamovil-{country}-rvc2
                    setprop ro.mot.gms.clientidbase.vs android-americamovil-{country}-rvc2
                fi
            else
                setprop ro.mot.gms.clientidbase.ms android-americamovil-{country}-revc
            fi
            setprop ro.mot.gms.clientidbase.am android-americamovil-{country}
        ;;
        # ATT Mexico
        attmx )
            if is_wave_at_least 2022.1 ; then
                setprop ro.mot.gms.clientidbase.ms android-attmexico-mx-rvc3
                setprop ro.mot.gms.clientidbase.vs android-attmexico-mx-rvc3
            else
                if is_wave_at_least 2019.1 ; then
                    setprop ro.mot.gms.clientidbase.ms android-attmexico-mx-revc
                else
                    setprop ro.mot.gms.clientidbase.ms android-motorola-rev2
                fi
            fi
        ;;
        # 3GB and Wind/3 Italy (same company)
        3gb|windit )
            if is_wave_at_least 2022.1 ; then
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.ms android-h3g-{country}-rvc3
                else
                    setprop ro.mot.gms.clientidbase.ms android-h3g-{country}-rvc2
                fi
                setprop ro.mot.gms.clientidbase.cr android-motorola
            else
                setprop ro.mot.gms.clientidbase.ms android-h3g-{country}-revc
            fi
            setprop ro.mot.gms.clientidbase.ms android-h3g-{country}-revc
        ;;
        # Telstra AU
        telstra )
            if is_wave_at_least 2023.1 ; then
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.vs android-telstra-au-rvc3
                else
                    setprop ro.mot.gms.clientidbase.vs android-telstra-au-rvc2
                fi
            fi
            if is_wave_at_least 2021.3 ; then
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.ms android-telstra-au-rvc3
                else
                    setprop ro.mot.gms.clientidbase.ms android-telstra-au-rvc2
                fi
            else
                setprop ro.mot.gms.clientidbase.ms android-telstra-au-revc
            fi
            setprop ro.mot.gms.clientidbase.am android-telstra-au
            setprop ro.mot.gms.clientidbase.wal android-telstra-au
        ;;
        # TIM Italy - timit
        timit )
            if is_wave_at_least 2022.1 ; then
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.ms android-tim-it-rvc3
                else
                    setprop ro.mot.gms.clientidbase.ms android-tim-it-rvc2
                fi
                setprop ro.mot.gms.clientidbase.cr android-motorola
            else
                setprop ro.mot.gms.clientidbase.ms android-tim-it-revc
            fi
        ;;
        # TIM Brazil - timbr
        timbr )
            if is_wave_at_least 2019.3 ; then
                setprop ro.mot.gms.clientidbase.ms android-tim-br-revc
            else
                setprop ro.mot.gms.clientidbase.ms android-motorola-rev2
            fi
        ;;
        # Bouygues France - bouyfr
        bouyfr )
            if is_wave_at_least 2021.3 ; then
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.ms android-bouygues-fr-rvc3
                else
                    setprop ro.mot.gms.clientidbase.ms android-bouygues-fr-rvc2
                fi
                setprop ro.mot.gms.clientidbase.cr android-motorola
            else
                setprop ro.mot.gms.clientidbase.ms android-bouygues-fr-revc
            fi
        ;;
        # Telus Canada - tkpca
        tkpca )
            setprop ro.mot.gms.clientidbase.ms android-telus-ca-revc
        ;;
        # Vodafone Australia - vfau
        vfau )
            if is_wave_at_least 2021.2 ; then
                setprop ro.mot.gms.clientidbase.am android-vf-au
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.ms android-vf-au-rvc3
                else
                    setprop ro.mot.gms.clientidbase.ms android-vf-au-rvc2
                fi
            else
                setprop ro.mot.gms.clientidbase.ms android-vf-au-revc
            fi
        ;;
        # Telenor - Hungary
        telhu )
            setprop ro.mot.gms.clientidbase.ms android-telenor-{country}-revc
        ;;
        # Telenor Nordics before 2018.4 / Non-EEA countries after
        teleu )
            if is_wave_at_least 2018.4 ; then
                # Legacy implementation
                if [ $gms_premier_tier == true ]; then
                    setprop ro.mot.gms.clientidbase.ms android-motorola-rvo3
                else
                    setprop ro.mot.gms.clientidbase.ms android-motorola-rev2
                fi
            else
                setprop ro.mot.gms.clientidbase.ms android-telenor-{country}-revc
            fi
        ;;

        # APEM Region - SOftbank Japan
        softbank|ymobile )
            setprop ro.mot.gms.clientidbase.am android-softbank-jp
        ;;

        # Optus AU
        optus )
            setprop ro.mot.gms.clientidbase.ms android-optus-au-rvc3
            setprop ro.mot.gms.clientidbase.vs android-optus-au-rvc3
            setprop ro.mot.gms.clientidbase.am android-optus-au
        ;;

        # For China product, the "ro.google.gms.clientidbase.ms" should not be set.
        retcn|cmcc|ctcn|cucn )
            setprop ro.mot.gms.clientidbase.ms ""
        ;;

        # GMS properties by default
        * )
            if [ $gms_premier_tier == true ]; then
                setprop ro.mot.gms.clientidbase.ms android-motorola-rvo3
            else
                setprop ro.mot.gms.clientidbase.ms android-motorola-rev2
            fi
        ;;
    esac # end $carrier for GMS
}

# Set Google revenue share property
set_google_revenue_share_property ()
{
    whitelist=y0,y5,y6,y7,y8
    rlz_base=`getprop ro.mot.gms.rlz_base_prop`
    if [ $rlz_base ]; then
        whitelist=$rlz_base
    fi

    rlz_brandcode=`getprop ro.com.google.rlzbrandcode`
    if [ $rlz_brandcode ]; then
        if is_wave_at_least 2018.4 ; then
            # Google revenue share property must be set different for
            # carriers which Google News is not being installed
            case $boot_carrier in
                comcast|tracfone|vzw|vzwpre|sprint|boost|cricket|att|attpre )
                ;;
                * )
                    whitelist=$whitelist,YH
                ;;
            esac
        fi
        setprop ro.mot.gms.rlz_ap_whitelist $whitelist
    fi
}

# Set sprint client id base on persist.carrier.carrierid
set_sprint_google_clientid_properties ()
{
    case $carrierid in
        SPRINT )
            setprop ro.mot.gms.clientidbase.ms $sprintclientid
        ;;
        BOOST )
            setprop ro.mot.gms.clientidbase.ms $sprintclientid
        ;;
        VIRGIN )
            setprop ro.mot.gms.clientidbase.ms $sprintclientid
        ;;
        SPRPRE )
            setprop ro.mot.gms.clientidbase.ms $sprintclientid
        ;;
        310470|312420|312570|310580|312720|310130|311910|311450|311670|311230 )
            setprop ro.mot.gms.clientidbase.ms $sprintclientid
        ;;
        # for any new carrier id, just set it to the value in Chameleon
        * )
            setprop ro.mot.gms.clientidbase.ms $sprintclientid
        ;;
    esac # end carrierid for sprint

    case $omadm_operator in
        310000 )
            setprop ro.mot.gms.clientidbase.ms $sprintclientid
        ;;
    esac
}

# Set additional properties base on carrier -- early-init
set_carrier_readonly_properties ()
{
    case $boot_carrier in
        att|attpre )
            setprop ro.facebook.partnerid att:4b2a1409-4fa0-4d4c-a184-95f0f26d4192
            setprop ro.csc.amazon.partnerid att
        ;;
        attmx )
            setprop ro.csc.amazon.partnerid attmx
        ;;
        cricket )
            setprop ro.facebook.partnerid cricket:b8be48cb-7b34-13cd-1ed7-4b90bc649fcd
            setprop ro.csc.amazon.partnerid cricket
        ;;
        tmo )
            setprop ro.facebook.partnerid t-mobile:05b925b2-7fe4-44c4-9a36-7f101502cdb2
            setprop ro.csc.amazon.partnerid tmobile
        ;;
        metropcs )
            setprop ro.facebook.partnerid metropcs:d23ba4e0-3b37-4a4b-9ccb-7be7680cb157
        ;;
        usc )
            setprop cdma.operator.numeric 311580
            setprop ro.cdma.home.operator.numeric 311580
            setprop ro.cdma.home.operator.alpha "U.S. Cellular"
        ;;
        oraeu )
            setprop media.httplive.kdlblocksize 1920
            setprop ro.product.brand1 orange
        ;;
        oraes|orafr )
            setprop media.httplive.kdlblocksize 1920
        ;;
        sprint )
            setprop ro.csc.amazon.partnerid sprint
        ;;
        boost )
            setprop ro.csc.amazon.partnerid boost
        ;;
        vzw|vzwpre )
            setprop ro.csc.amazon.partnerid verizon
        ;;
        rcica )
            setprop ro.csc.amazon.partnerid rogers
        ;;
        tkpca )
            setprop ro.csc.amazon.partnerid telus
        ;;
        tefes )
            setprop ro.csc.amazon.partnerid telefonica
        ;;
        timit )
            setprop ro.csc.amazon.partnerid timit
        ;;
        windit )
            setprop ro.csc.amazon.partnerid 3it
        ;;
        vfau )
            setprop ro.csc.amazon.partnerid vfau
        ;;
        tefpe|tefco )
            setprop ro.setupwizard.require_network any
            setprop ro.setupwizard.user_req_network any
        ;;
    esac

    case $carrierid in
        BOOST )
            setprop ro.csc.amazon.partnerid boost
        ;;

        VIRGIN )
            setprop ro.csc.amazon.partnerid virgin
        ;;
    esac
}

# Additional operation for carrier when phone boot complete
set_boot_complete_operation ()
{
    case $carrier in
        attmx | rcica | usc )
            if [ -f  /oem/$carrier/amzn.mshop.properties ]; then
                 mkdir -p /data/vendor/Amazon\ Video/raw/
                 chown system:system /data/vendor/Amazon\ Video/
                 chmod 0755 /data/vendor/Amazon\ Video/
                 chown system:system /data/vendor/Amazon\ Video/raw/
                 chmod 0755  /data/vendor/Amazon\ Video/raw/
                 ln -s /oem/$carrier/amzn.mshop.properties data/vendor/Amazon\ Video/raw/amzn.mshop.properties
            fi
        ;;
        tmo | metropcs )
            setprop ro.sys.force_max_chrg_temp 55
        ;;
    esac
}

set_demo_mode_operation ()
{
    if [ $carrier == vzw ] || [ $carrier == vzwpre ]; then
        setprop ro.sys.force_demo_mode 35
    else
        setprop ro.sys.force_demo_mode 70
    fi
}

# set the persist property for carrier media dir
set_carrier_media_dir_property ()
{
    propMediaDir=`getprop persist.carrier.media.dir`
    if [ ! $propMediaDir ]; then
        propChannelId=$carrier
        # On legacy Q products, the ota-updated channel-id is persisted to
        # persist.carrier.media. So, use it if it exists.
        propUpdatedChannelId = `getprop persist.carrier.media`
        if [ $propUpdatedChannelId ]; then
            propChannelId=$propUpdatedChannelId;
        fi
        setprop persist.carrier.media.dir /product/carrier/$propChannelId/media
    fi
}

# The main code
if [ ! -z "$init_early_property" ]; then
    set_carrier_readonly_properties
    set_google_revenue_share_property
    set_carrier_media_dir_property
    return 0
fi

if [ ! -z "$post_property_overlay" ]; then
    set_google_clientid_properties
    return 0
fi

if [ ! -z "$post_sprint_property" ]; then
   if [ $carrier == sprint ] || [ $carrier == boost ]; then
      set_sprint_google_clientid_properties
   fi
   return 0
fi

if [ ! -z "$boot_complete_operation" ]; then
   set_boot_complete_operation
   return 0
fi

if [ ! -z "$demo_mode_operation" ]; then
   set_demo_mode_operation
   return 0
fi

return 0

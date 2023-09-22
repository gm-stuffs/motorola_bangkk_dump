#
# Copyright (C) 2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from bangkk device
$(call inherit-product, device/motorola/bangkk/device.mk)

PRODUCT_DEVICE := bangkk
PRODUCT_NAME := lineage_bangkk
PRODUCT_BRAND := motorola
PRODUCT_MODEL := Holi for arm64
PRODUCT_MANUFACTURER := motorola

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="bangkk_g-user 11 T3TC33.18-12-3 6138c release-keys"

BUILD_FINGERPRINT := motorola/bangkk_g/bangkk:11/T3TC33.18-12-3/6138c:user/release-keys

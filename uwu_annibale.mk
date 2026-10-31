#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from generic device
$(call inherit-product, device/xiaomi/annibale/device.mk)

# Inherit some common Lineage stuff.
UWU_DEVICE_TYPE := phone
UWU_SUPPORTS_TELEPHONY := true
UWU_MAINTAINER := Nogihhq
$(call inherit-product, vendor/uwu/config/common.mk)

# Inherit from the MiuiCamera setup
$(call inherit-product-if-exists, device/xiaomi/annibale-miuicamera/device.mk)

# Lineage stuff
TARGET_EXCLUDES_AUDIOFX := true

PRODUCT_NAME := uwu_annibale
PRODUCT_DEVICE := annibale
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := 2510DRK44C
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

# 伪装成国行 REDMI K90 的 HyperOS 4.0.5.0 指纹（值取自实机 getprop）
PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="annibale-user 17 CP2A.260605.016 OS4.0.5.0.XPKCNXM release-keys" \
    BuildFingerprint="Redmi/annibale/annibale:17OS4.0.5.0.XPKCNXM:user/release-keys"

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
    BuildFingerprint="Redmi/annibale/annibale:17/CP2A.260605.016/OS4.0.5.0.XPKCNXM:user/release-keys" \
    BuildVariant=user \
    BuildFlavor=annibale-user

# ro.system.build.fingerprint 与 ro.build 对齐（Maple fingerprint_invalid：指纹必须 7 段 BRAND/PRODUCT/DEVICE:VERSION/ID/INCREMENTAL:TAGS）
BUILD_SYSTEM_FINGERPRINT := Redmi/annibale/annibale:17/CP2A.260605.016/OS4.0.5.0.XPKCNXM:user/release-keys

# 本机是 4KB page size 设备：GKI 版本号里带 -4k
# （GKI_VERSION := 6.6.118-android15-8-ge56cf6b09cca-ab15511674-4k），
# 厂商预编译的 .so（cronet、libprotobuf 等）Load 段对齐都是 4096。
# 不显式声明的话，build/make/core/config.mk 在 arm64 + VSR>=34 时默认按
# 16384 校验，check_elf_file 会大面积报
# "Load segment has alignment 4096 but 16384 required"。
PRODUCT_MAX_PAGE_SIZE_SUPPORTED := 4096

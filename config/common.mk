# Copyright (C) 2022-2023 The LeafOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)
$(call inherit-product-if-exists, vendor/extra/product.mk)

# Adblock
PRODUCT_PACKAGES += \
    hosts.adblock

PRODUCT_COPY_FILES += \
    vendor/leaf/etc/init/init.adblock.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.adblock.rc

# Apps
PRODUCT_PACKAGES += \
    Etar \
    ExactCalculator

# Bootanimation
TARGET_SCREEN_WIDTH ?= 1080

PRODUCT_PACKAGES += \
    bootanimation.zip

# Browser
PRODUCT_PACKAGES += \
    TrichromeChrome6432 \
    TrichromeWebView6432

# Charger
PRODUCT_PACKAGES += \
    leaf_charger \
    leaf_charger_vendor

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# Customization
PRODUCT_PACKAGES += \
    LeafBackgrounds \
    ThemePicker \
    DefaultThemesStub

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    Launcher3QuickStep

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Compile SystemUI on device with `speed`.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.systemuicompilerfilter=speed

# FaceUnlock
ifneq ($(TARGET_FACE_UNLOCK_OPTOUT), true)
PRODUCT_PACKAGES += \
    FaceUnlockOverlay \
    LMOFaceUnlock

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# Google apps
ifeq ($(WITH_GMS), true)
$(call inherit-product, vendor/gapps/gms.mk)
endif
ifeq ($(WITH_MICROG), true)
$(call inherit-product, vendor/microg/products/gms.mk)
endif

# Leaf packages
PRODUCT_PACKAGES += \
    LeafSetupWizard \
    Updater

# OTA
PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/leaf/build/target/product/security/leaf

# Overlays
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += \
    vendor/leaf/overlay/no-rro

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/leaf/overlay/common \
    vendor/leaf/overlay/no-rro

PRODUCT_PACKAGES += \
    NetworkStackOverlay

# Translations
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/crowdin/overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/crowdin/overlay

# PDF
PRODUCT_PACKAGES += \
    MuPDF

# Permissions
PRODUCT_COPY_FILES += \
    vendor/leaf/config/permissions/privapp-permissions-settings.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-settings.xml

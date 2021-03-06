# Copyright (C) 2022 The LeafOS Project
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

include vendor/leaf/config/version.mk
$(call inherit-product-if-exists, vendor/extra/product.mk)

# Apps
PRODUCT_PACKAGES += \
    Etar

# Browser
PRODUCT_PACKAGES += \
    Bromite \
    BromiteWebView

# Charger
PRODUCT_PACKAGES += \
    leaf_charger

# Customization
PRODUCT_PACKAGES += \
    LeafBackgrounds \
    ThemePicker \
    DefaultThemesStub

# Google apps
ifeq ($(WITH_GMS), true)
$(call inherit-product, vendor/gapps/gms.mk)
endif
ifeq ($(WITH_MICROG), true)
$(call inherit-product, vendor/microg/products/gms.mk)
endif

# Lawnicons
$(call inherit-product-if-exists, vendor/lawnicons/overlay.mk)

# Leaf packages
PRODUCT_PACKAGES += \
    Updater

# Overlays
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += \
    vendor/leaf/overlay/no-rro

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/leaf/overlay/common \
    vendor/leaf/overlay/no-rro

# Required packages
PRODUCT_PACKAGES += \
    androidx.window.extensions

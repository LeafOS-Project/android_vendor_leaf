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

PRODUCT_VERSION_MAJOR := 2
PRODUCT_VERSION_MINOR := 0

ifeq ($(LEAF_VERSION_APPEND_TIME_OF_DAY),true)
    LEAF_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    LEAF_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

# If unset set LEAF_BUILDTYPE to the env variable RELEASE_TYPE, or
# if that doesn't exist to "UNOFFICIAL"
ifndef LEAF_BUILDTYPE
    ifdef RELEASE_TYPE
        LEAF_BUILDTYPE := $(RELEASE_TYPE)
    else
        LEAF_BUILDTYPE := UNOFFICIAL
    endif
endif

ifdef LEAF_EXTRAVERSION
    LEAF_EXTRAVERSION := -$(LEAF_EXTRAVERSION)
endif

LEAF_FLAVOR ?= VANILLA

ifeq ($(WITH_GMS), true)
LEAF_FLAVOR := GMS
endif
ifeq ($(WITH_MICROG), true)
LEAF_FLAVOR := microG
endif

# Internal version
LEAF_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)

# Display version
LEAF_DISPLAY_VERSION := $(LEAF_VERSION)$(LEAF_EXTRAVERSION)-$(LEAF_BUILDTYPE)-$(LEAF_FLAVOR)-$(LEAF_BUILD)

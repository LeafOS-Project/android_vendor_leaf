#
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
#
# Setup SOONG_CONFIG_* vars to export the vars listed above.
SOONG_CONFIG_NAMESPACES += leafVarsPlugin
SOONG_CONFIG_leafVarsPlugin :=

define addVar
  SOONG_CONFIG_leafVarsPlugin += $(1)
  SOONG_CONFIG_leafVarsPlugin_$(1) := $$(subst ",\",$$($1))
endef

$(foreach v,$(EXPORT_TO_SOONG),$(eval $(call addVar,$(v))))

SOONG_CONFIG_NAMESPACES += leafGlobalVars
SOONG_CONFIG_leafGlobalVars += \
    target_init_vendor_lib

# Set default values
TARGET_INIT_VENDOR_LIB ?= vendor_init

# Soong value variables
SOONG_CONFIG_leafGlobalVars_target_init_vendor_lib := $(TARGET_INIT_VENDOR_LIB)

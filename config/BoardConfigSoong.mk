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

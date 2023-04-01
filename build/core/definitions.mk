#
# Leaf-specific macros
#
define uniq
$(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))
endef

# Include board/platform macros
include vendor/leaf/build/core/utils.mk

# Include vendor platform definitions
include vendor/leaf/build/core/vendor/*.mk

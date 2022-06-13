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

LOCAL_7Z_EXT := $(shell echo $(LOCAL_SRC_FILES) | cut -f2 -d '.')
LOCAL_7Z_FILES := $(LOCAL_PATH)/$(LOCAL_SRC_FILES)
$(PRODUCT_OUT)/obj/7Z_PREBUILTS/$(LOCAL_MODULE).$(TARGET_ARCH).$(LOCAL_7Z_EXT):
	@mkdir -p $(dir $@)
	@prebuilts/tools-leaf/$(HOST_PREBUILT_TAG)/bin/7z e -txz -so $(LOCAL_7Z_FILES) > $@

LOCAL_SRC_FILES := $(shell echo $(LOCAL_PATH) | sed 's/[a-zA-Z0-9]*/../g')/$(PRODUCT_OUT)/obj/7Z_PREBUILTS/$(LOCAL_MODULE).$(TARGET_ARCH).$(LOCAL_7Z_EXT)
include $(BUILD_PREBUILT)

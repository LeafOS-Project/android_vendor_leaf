#
# Copyright (C) 2023 The LeafOS Project
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

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
HOSTS_ADBLOCK := $(TARGET_OUT_ETC)/hosts.adblock
$(HOSTS_ADBLOCK): $(LOCAL_INSTALLED_MODULE)
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) cp system/core/rootdir/etc/hosts $@

HOSTS_ADBLOCK_SYMLINK := $(TARGET_OUT_ETC)/hosts
$(HOSTS_ADBLOCK_SYMLINK): $(LOCAL_INSTALLED_MODULE) $(HOSTS_ADBLOCK)
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf hosts.adblock $@

ALL_DEFAULT_INSTALLED_MODULES += $(HOSTS_ADBLOCK_SYMLINK)

include $(call all-makefiles-under,$(LOCAL_PATH))

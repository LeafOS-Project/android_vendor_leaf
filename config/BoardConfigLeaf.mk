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

include vendor/leaf/config/BoardConfigKernel.mk
ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/leaf/config/BoardConfigQcom.mk
endif
include vendor/leaf/config/BoardConfigSoong.mk
include vendor/leaf/config/BoardConfigVersion.mk
-include vendor/extra/BoardConfigExtra.mk

include device/leaf/sepolicy/common/sepolicy.mk
include device/lineage/sepolicy/common/sepolicy.mk

# Recovery
BOARD_USES_FULL_RECOVERY_IMAGE := true

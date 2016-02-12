#
# Copyright (C) 2011 The Android Open-Source Project
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
# Everything in this directory will become public

## Specify phone tech before including full_phone
#$(call inherit-product, vendor/cm/config/gsm.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/lge/p920/p920.mk)

PRODUCT_NAME := cm_p920

# Release name and versioning
PRODUCT_RELEASE_NAME := Optimus3D
PRODUCT_VERSION_DEVICE_SPECIFIC :=
-include vendor/cm/config/common_versions.mk

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := p920

# Enable Torch
PRODUCT_PACKAGES += Torch

PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=cosmopolitan BUILD_ID=GRJ90 BUILD_FINGERPRINT="lge/cosmopolitan/cosmo_EUR-XXX:2.3.5/GRJ90/LGP920-V21a.19defbe655:user/release-keys" PRIVATE_BUILD_DESC="cosmopolitan-user 2.3.5 GRJ90 LGP920-V21a-NOV-15-2011.423ad6cf release-keys"

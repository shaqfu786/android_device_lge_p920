## Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/gsm.mk)

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

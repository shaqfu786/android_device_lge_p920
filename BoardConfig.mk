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

# This file includes all definitions that apply to ALL p920 devices, and
# are also specific to p920 devices
#
# Everything in this directory will become public

COMMON_FOLDER := device/lge/p920

-include vendor/lge/p920/BoardConfigVendor.mk

# Headers
TARGET_SPECIFIC_HEADER_PATH := $(COMMON_FOLDER)/include
PRODUCT_VENDOR_KERNEL_HEADERS := $(COMMON_FOLDER)/kernel-headers

# Cpu
TARGET_NO_BOOTLOADER := true
TARGET_BOARD_PLATFORM := omap4
TARGET_BOARD_OMAP_CPU := 4430
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_BOOTLOADER_BOARD_NAME := p920
TARGET_CPU_SMP := true
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_ARCH_VARIANT_CPU := cortex-a9
TARGET_ARCH_VARIANT_FPU := neon
TARGET_CPU_VARIANT  := $(TARGET_ARCH_VARIANT_CPU)
ARCH_ARM_HAVE_TLS_REGISTER := true
TARGET_ARCH_LOWMEM := true
NEEDS_ARM_ERRATA_754319_754320 := true
BOARD_GLOBAL_CFLAGS += -DNEEDS_ARM_ERRATA_754319_754320
TARGET_BOARD_INFO_FILE := $(COMMON_FOLDER)/board-info.txt


# Boot
#BOARD_USES_UBOOT_MULTIIMAGE := true
#BOARD_UBOOT_ENTRY := 0x80008000
#BOARD_UBOOT_LOAD := 0x80008000
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_CMDLINE := androidboot.selinux=permissive 


# Kernel
TARGET_KERNEL_CONFIG := cyanogenmod_p920_defconfig
TARGET_KERNEL_SOURCE := kernel/lge/omap4-common


KERNEL_WL12XX_MODULES:
	make clean -C hardware/ti/wlan/mac80211/compat_wl12xx
	make -j8 -C hardware/ti/wlan/mac80211/compat_wl12xx KERNEL_DIR=$(KERNEL_OUT) KLIB=$(KERNEL_OUT) KLIB_BUILD=$(KERNEL_OUT) ARCH=arm CROSS_COMPILE="arm-eabi-"
	mv hardware/ti/wlan/mac80211/compat_wl12xx/compat/compat.ko $(KERNEL_MODULES_OUT)
	mv hardware/ti/wlan/mac80211/compat_wl12xx/net/mac80211/mac80211.ko $(KERNEL_MODULES_OUT)
	mv hardware/ti/wlan/mac80211/compat_wl12xx/net/wireless/cfg80211.ko $(KERNEL_MODULES_OUT)
	mv hardware/ti/wlan/mac80211/compat_wl12xx/drivers/net/wireless/wl12xx/wl12xx.ko $(KERNEL_MODULES_OUT)
	mv hardware/ti/wlan/mac80211/compat_wl12xx/drivers/net/wireless/wl12xx/wl12xx_spi.ko $(KERNEL_MODULES_OUT)
	mv hardware/ti/wlan/mac80211/compat_wl12xx/drivers/net/wireless/wl12xx/wl12xx_sdio.ko $(KERNEL_MODULES_OUT)
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/compat.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/mac80211.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/cfg80211.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/wl12xx.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/wl12xx_spi.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/wl12xx_sdio.ko

TARGET_KERNEL_MODULES += KERNEL_WL12XX_MODULES

# External SGX Module
SGX_MODULES:
	make clean -C $(COMMON_FOLDER)/sgx-module/eurasiacon/build/linux2/omap4430_android
	cp $(TARGET_KERNEL_SOURCE)/drivers/video/omap2/omapfb/omapfb.h $(KERNEL_OUT)/drivers/video/omap2/omapfb/omapfb.h
	make -j8 -C $(COMMON_FOLDER)/sgx-module/eurasiacon/build/linux2/omap4430_android ARCH=arm KERNEL_CROSS_COMPILE=arm-eabi- CROSS_COMPILE=arm-eabi- KERNELDIR=$(KERNEL_OUT) TARGET_PRODUCT="blaze_tablet" BUILD=release TARGET_SGX=540 PLATFORM_VERSION=4.0
	mv $(KERNEL_OUT)/../../target/kbuild/pvrsrvkm_sgx540_120.ko $(KERNEL_MODULES_OUT)
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/pvrsrvkm_sgx540_120.ko

TARGET_KERNEL_MODULES += SGX_MODULES 


# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_TI := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(COMMON_FOLDER)/bluetooth
BOARD_NEEDS_CUTILS_LOG := true

# Egl
USE_OPENGL_RENDERER := true
BOARD_EGL_CFG := $(COMMON_FOLDER)/prebuilt/egl.cfg
BOARD_EGL_WORKAROUND_BUG_10194508 := true
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true
TARGET_USES_OPENGLES_FOR_SCREEN_CAPTURE := true
#TARGET_HAS_WAITFORVSYNC := true


# Wifi
USES_TI_MAC80211 := true
COMMON_GLOBAL_CFLAGS += -DUSES_TI_MAC80211 
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
WPA_SUPPLICANT_VERSION           := VER_0_8_X_TI
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_wl12xx
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_wl12xx
BOARD_WLAN_DEVICE                := wl12xx_mac80211
BOARD_SOFTAP_DEVICE              := wl12xx_mac80211
PRODUCT_WIRELESS_TOOLS           := true
WIFI_DRIVER_MODULE_PATH          := "/system/lib/modules/wl12xx_sdio.ko"
WIFI_DRIVER_MODULE_NAME          := "wl12xx_sdio"
WIFI_FIRMWARE_LOADER             := ""
BOARD_WIFI_SKIP_CAPABILITIES     := true
WIFI_BAND := 802_11_ABGN
PRODUCT_PROPERTY_OVERRIDES := \
       wifi.interface=wlan0
	   
	   
# Filesystem
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 619249664
#BOARD_USERDATAIMAGE_PARTITION_SIZE := 1056858112
#BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
#BOARD_CACHEIMAGE_PARTITION_SIZE := 64656016
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_VOLD_MAX_PARTITIONS := 16
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
BOARD_HAS_NO_MISC_PARTITION := true

# Camera
USE_CAMERA_STUB := false


# Omap-Enhancements
# TI Enhancement Settings (Part 1)
HARDWARE_OMX := true
OMAP_ENHANCEMENT := true
#OMAP_ENHANCEMENT_S3D := true
OMAP_ENHANCEMENT_MULTIGPU := true
#OMAP_ENHANCEMENT_CPCAM := true
ifdef OMAP_ENHANCEMENT
    COMMON_GLOBAL_CFLAGS += -DOMAP_ENHANCEMENT -DTARGET_OMAP4 -DFORCE_SCREENSHOT_CPU_PATH 
endif

ifdef OMAP_ENHANCEMENT_S3D
    COMMON_GLOBAL_CFLAGS += -DOMAP_ENHANCEMENT_S3D
endif

ifdef OMAP_ENHANCEMENT_CPCAM
    COMMON_GLOBAL_CFLAGS += -DOMAP_ENHANCEMENT_CPCAM
    PRODUCT_MAKEFILES += $(LOCAL_DIR)/sdk_addon/ti_omap_addon.mk
endif

ifdef OMAP_ENHANCEMENT_MULTIGPU
    COMMON_GLOBAL_CFLAGS += -DOMAP_ENHANCEMENT_MULTIGPU
endif
# TI Enhancement Settings (Part 2)
BOARD_USE_TI_ENHANCED_DOMX := true
ifdef BOARD_USE_TI_ENHANCED_DOMX
    BOARD_USE_TI_DUCATI_H264_PROFILE := true
    TI_CUSTOM_DOMX_PATH := $(COMMON_FOLDER)/domx
    DOMX_PATH := $(COMMON_FOLDER)/domx
    ENHANCED_DOMX := true
else
    DOMX_PATH := hardware/ti/omap4xxx/domx
endif

BOARD_RIL_CLASS := ../../../device/lge/p920/ril/
BOARD_HAS_VIBRATOR_IMPLEMENTATION := ../../device/lge/p920/vibrator.c

BOARD_ALLOW_SUSPEND_IN_CHARGER := true

# Hardware
BOARD_HARDWARE_CLASS := $(COMMON_FOLDER)/cmhw

# Setup custom omap4xxx defines
BOARD_USE_CUSTOM_LIBION := true

BOARD_HAL_STATIC_LIBRARIES := libhealthd.p920
TARGET_TI_HWC_HDMI_DISABLED := true


# Recovery
HAVE_SELINUX := true
BOARD_RECOVERY_ALWAYS_WIPES := true
TARGET_RECOVERY_PRE_COMMAND := "echo 1 > /data/.recovery_mode; sync; \#"
BOARD_HAS_SDCARD_INTERNAL := true
TARGET_RECOVERY_FSTAB = $(COMMON_FOLDER)/root/fstab.lgep920board
RECOVERY_FSTAB_VERSION = 2 
DEVICE_RESOLUTION := 480x800
#BOARD_CUSTOM_BOOTIMG_MK := device/lge/p920/uboot-bootimg.mk
BOARD_HAS_NO_SELECT_BUTTON := true
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
BOARD_RECOVERY_SWIPE := true
BOARD_UMS_LUNFILE := "/sys/devices/virtual/android_usb/android0/f_mass_storage/lun%d/file"
#USE_SET_METADATA := false
#RECOVERY_GRAPHICS_USE_LINELENGTH := true
#TW_CRYPTO_FS_TYPE := "ext4"
#TW_FLASH_FROM_STORAGE := true 
#TW_INTERNAL_STORAGE_PATH := "/storage/sdcard0"
#TW_INTERNAL_STORAGE_MOUNT_POINT := "sdcard"
#TW_EXTERNAL_STORAGE_PATH := "/storage/sdcard1"
#TW_EXTERNAL_STORAGE_MOUNT_POINT := "external_sd"
#TW_MAX_BRIGHTNESS := 254
#TW_BRIGHTNESS_PATH := /sys/devices/platform/omap/omap_i2c.2/i2c-2/2-0036/brightness

 
# Audio
#BOARD_USES_AUDIO_LEGACY := true
BOARD_USES_GENERIC_AUDIO := false
#BOARD_USES_ALSA_AUDIO := true
#BUILD_WITH_ALSA_UTILS := true
#TARGET_PROVIDES_LIBAUDIO := true
HAVE_PRE_KITKAT_AUDIO_BLOB :=true


# Fm-Radio
TARGET_PROVIDES_TI_FM_SERVICE := true

# Selinux
BOARD_USES_SECURE_SERVICES := true

# Sepolicy
BOARD_SEPOLICY_DIRS += \
	$(COMMON_FOLDER)/sepolicy
	
BOARD_SEPOLICY_UNION += \
    bluetooth.te \
    device.te \
    domain.te \
    file.te \
    file_contexts \
    healthd.te \
    pvrsrvinit.te 


COMMON_GLOBAL_CFLAGS += -DBOARD_CHARGING_CMDLINE_NAME='"chg"' 
COMMON_GLOBAL_CFLAGS += -DBOARD_CHARGING_CMDLINE_VALUE='"4"'

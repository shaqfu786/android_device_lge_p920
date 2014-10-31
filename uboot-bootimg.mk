#
# Copyright (C) 2011 The Cyanogenmod Project
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

#
# To use this bootimg 
#  
#  Add to your BoardConfig.mk:
#    BOARD_CUSTOM_BOOTIMG_MK := device/common/uboot-bootimg.mk
#  If using uboot multiimage add:
#    BOARD_USES_UBOOT_MULTIIMAGE := true
# 

#
# Ramdisk/boot image
#
LOCAL_PATH := $(call my-dir)

PRODUCT_VERSION = CM-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)

ifeq ($(BOARD_USES_UBOOT_MULTIIMAGE),true)
    ifneq ($(strip $(TARGET_NO_KERNEL)),true)

        INSTALLED_BOOTIMAGE_TARGET := $(PRODUCT_OUT)/boot.img

        INTERNAL_UBOOT_MULTIIMAGENAME := $(PRODUCT_VERSION)-$(TARGET_DEVICE)-Multiboot

        INTERNAL_UMULTIIMAGE_ARGS := -A ARM -O Linux -T multi -C none -n "$(INTERNAL_UBOOT_MULTIIMAGENAME)"

        BOARD_UBOOT_ENTRY := $(strip $(BOARD_UBOOT_ENTRY))
        ifdef BOARD_UBOOT_ENTRY
            INTERNAL_UMULTIIMAGE_ARGS += -e $(BOARD_UBOOT_ENTRY)
        endif

        BOARD_UBOOT_LOAD := $(strip $(BOARD_UBOOT_LOAD))
        ifdef BOARD_UBOOT_LOAD
            INTERNAL_UMULTIIMAGE_ARGS += -a $(BOARD_UBOOT_LOAD)
        endif

        ZIP_SAVE_UBOOTIMG_ARGS := $(INTERNAL_UMULTIIMAGE_ARGS)

        INTERNAL_UMULTIIMAGE_ARGS += -d $(INSTALLED_KERNEL_TARGET):$(BUILT_RAMDISK_TARGET)
$(INSTALLED_BOOTIMAGE_TARGET): $(MKIMAGE) $(INTERNAL_RAMDISK_FILES) $(BUILT_RAMDISK_TARGET) $(INSTALLED_KERNEL_TARGET)
			$(MKIMAGE) $(INTERNAL_UMULTIIMAGE_ARGS) $@
			@echo ----- Made uboot multiimage -------- $@

    endif #!TARGET_NO_KERNEL
endif

#
# Recovery Image
#
INSTALLED_RECOVERYIMAGE_TARGET := $(PRODUCT_OUT)/recovery.img
recovery_ramdisk := $(PRODUCT_OUT)/ramdisk-recovery.img
INTERNAL_RECOVERYRAMDISK_IMAGENAME := CWM $(TARGET_DEVICE) Ramdisk
INTERNAL_RECOVERYRAMDISKIMAGE_ARGS := -A ARM -O Linux -T RAMDisk -C none -n "$(INTERNAL_RECOVERYRAMDISK_IMAGENAME)" -d $(recovery_ramdisk)
recovery_uboot_ramdisk := $(recovery_ramdisk:%.img=%.ub)


ifeq ($(BOARD_USES_UBOOT_MULTIIMAGE),true)
    $(warning We are here.)
    INTERNAL_RECOVERYIMAGE_IMAGENAME := CWM $(TARGET_DEVICE) Multiboot
    INTERNAL_RECOVERYIMAGE_ARGS := -A arm -T multi -C none -n "$(INTERNAL_RECOVERYIMAGE_IMAGENAME)"

    BOARD_UBOOT_ENTRY := $(strip $(BOARD_UBOOT_ENTRY))
    ifdef BOARD_UBOOT_ENTRY
        INTERNAL_RECOVERYIMAGE_ARGS += -e $(BOARD_UBOOT_ENTRY)
    endif

BOARD_UBOOT_LOAD := $(strip $(BOARD_UBOOT_LOAD))

ifdef BOARD_UBOOT_LOAD
  INTERNAL_RECOVERYIMAGE_ARGS += -a $(BOARD_UBOOT_LOAD)
endif

UBOOT_DATA_ARGS = $(shell echo $(recovery_kernel):$(recovery_ramdisk)|sed -e 's/[[:space:]]//g')
INTERNAL_RECOVERYIMAGE_ARGS += -d $(UBOOT_DATA_ARGS)

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKIMAGE) \
               $(recovery_ramdisk) \
               $(recovery_kernel)
	@echo ----- Making recovery uboot image ------
	$(MKIMAGE) $(INTERNAL_RECOVERYIMAGE_ARGS) $@
	@echo ----- Made recovery uboot image -------- $@
endif

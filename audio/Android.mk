LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= AudioPolicyManager.cpp
LOCAL_SHARED_LIBRARIES:= libc libcutils libutils libmedia
LOCAL_STATIC_LIBRARIES := libmedia_helper
LOCAL_WHOLE_STATIC_LIBRARIES:= libaudiopolicy_legacy
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE:= audio_policy.$(TARGET_BOOTLOADER_BOARD_NAME)
LOCAL_MODULE_TAGS := eng debug

ifeq ($(BOARD_HAVE_BLUETOOTH),true)
  LOCAL_CFLAGS += -DWITH_A2DP
endif

###
### OMAP HDMI AUDIO HAL
###

include $(CLEAR_VARS)

LOCAL_MODULE := audio.hdmi.$(TARGET_BOOTLOADER_BOARD_NAME)

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_SRC_FILES := hdmi_audio_hw.c \
	hdmi_audio_utils.c

LOCAL_C_INCLUDES += \
	external/tinyalsa/include \
	system/media/audio_utils/include \
	system/media/audio_effects/include
LOCAL_SHARED_LIBRARIES := liblog libcutils libtinyalsa libaudioutils libdl
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)


include $(CLEAR_VARS)

LOCAL_MODULE := audio.primary.$(TARGET_BOOTLOADER_BOARD_NAME)
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_SRC_FILES := audio_hw.c ril_interface.c
LOCAL_C_INCLUDES += \
	external/tinyalsa/include \
	$(call include-path-for, audio-utils) \
	$(call include-path-for, audio-effects)
LOCAL_SHARED_LIBRARIES := liblog libcutils libtinyalsa libaudioutils libdl
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

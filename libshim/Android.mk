LOCAL_PATH := $(call my-dir)

# libril
include $(CLEAR_VARS)

LOCAL_SRC_FILES := libril.cpp

LOCAL_SHARED_LIBRARIES := libbinder

LOCAL_MODULE := libril_shim
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES

include $(BUILD_SHARED_LIBRARY)

# lge-ril
include $(CLEAR_VARS)

LOCAL_SHARED_LIBRARIES := libnetutils
LOCAL_SRC_FILES := lge-ril.c
LOCAL_MODULE := lge-ril-shim
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

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

LOCAL_PATH := device/lge/p920

$(call inherit-product, hardware/ti/omap4/omap4.mk)


DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/postrecoveryboot.sh:recovery/root/sbin/postrecoveryboot.sh


# Boot animation 
TARGET_SCREEN_HEIGHT := 720
TARGET_SCREEN_WIDTH := 480

# Scripts and confs
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilt/66swap:system/etc/init.d/66swap \
    $(LOCAL_PATH)/prebuilt/setup-recovery:system/bin/setup-recovery \
    $(LOCAL_PATH)/prebuilt/enable-tiwlink:system/bin/enable-tiwlink \
    $(LOCAL_PATH)/prebuilt/lgcpversion:system/bin/lgcpversion \
    $(LOCAL_PATH)/prebuilt/TIInit_7.2.31.bts:system/etc/firmware/TIInit_7.2.31.bts


# Init Scripts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/root/init.p920.rc:root/init.p920.rc \
    $(LOCAL_PATH)/root/init.lgep920board.rc:root/init.lgep920board.rc \
    $(LOCAL_PATH)/root/init.lgep920board.usb.rc:root/init.lgep920board.usb.rc \
    $(LOCAL_PATH)/root/ueventd.lgep920board.rc:root/ueventd.lgep920board.rc \
    $(LOCAL_PATH)/root/fstab.lgep920board:root/fstab.lgep920board 

# Wifi
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifimac/wlan-precheck:system/bin/wlan-precheck \
    $(LOCAL_PATH)/wifimac/wifical.sh:system/bin/wifical.sh \
    $(LOCAL_PATH)/configs/RFMD_S_3.5.ini:system/etc/wifi/RFMD_S_3.5.ini \
    $(LOCAL_PATH)/configs/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
    $(LOCAL_PATH)/configs/hostapd.conf:system/etc/wifi/softap/hostapd.conf \
    $(LOCAL_PATH)/configs/hostapd.conf:system/etc/wifi/hostapd.conf \
    $(LOCAL_PATH)/configs/touch_dev.idc:system/usr/idc/touch_dev.idc \
    $(LOCAL_PATH)/configs/p2p_supplicant.conf:system/etc/wifi/p2p_supplicant.conf \
    $(LOCAL_PATH)/configs/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
    $(LOCAL_PATH)/configs/touch_dev.kl:system/usr/keylayout/touch_dev.kl

# stagefright confs
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media_profiles.xml:system/etc/media_profiles.xml \
    $(LOCAL_PATH)/configs/media_codecs.xml:system/etc/media_codecs.xml \
    $(LOCAL_PATH)/configs/audio_policy.conf:system/etc/audio_policy.conf

# RIL stuffs
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/ipc_channels.config:system/etc/ipc_channels.config

# Permission files
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.software.sip.xml:system/etc/permissions/android.software.sip.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml 
      
# GPS
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/gps_brcm_conf.xml:system/etc/gps_brcm_conf.xml \
    $(LOCAL_PATH)/configs/gps.conf:system/etc/gps.conf \
    $(LOCAL_PATH)/configs/SuplRootCert:system/etc/SuplRootCert 

# Camera
#PRODUCT_COPY_FILES += \
#    $(LOCAL_PATH)/prebuilt/libcameraservice.so:system/lib/libcameraservice.so

$(call inherit-product, build/target/product/full.mk)

PRODUCT_AAPT_CONFIG := normal hdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

# Wifi
PRODUCT_PACKAGES += \
    wlan_loader \
    wlan_cu \
    tiap_loader \
    tiap_cu \
    libnetcmdiface

# Audio
PRODUCT_PACKAGES += \
    libasound \
    libaudioutils \
    libaudiohw_legacy \
    audio.usb.default \
    audio.a2dp.default \
    audio.r_submix.default \
    audio_policy.p920 \
    tinyplay \
    tinycap \
    tinymix \
    tinypcminfo

# HALs
PRODUCT_PACKAGES += \
    audio.primary.p920 \
    audio.hdmi.p920 \
    hwcomposer.omap4\
    camera.omap4 \
    lights.p920 
    
# BlueZ test tools
PRODUCT_PACKAGES += \
    hciconfig \
    hcitool

# OMAP4 OMX
PRODUCT_PACKAGES += \
    libmm_osal \
    gralloc.omap4.so

# Misc
PRODUCT_PACKAGES += \
    libipcutils \
    libipc \
    libnotify \
    syslink_trace_daemon.out \
    librcm \
    libsysmgr \
    syslink_daemon.out \
    dmm_daemontest.out \
    event_listener.out \
    interm3.out \
    gateMPApp.out \
    heapBufMPApp.out \
    heapMemMPApp.out \
    listMPApp.out \
    messageQApp.out \
    nameServerApp.out \
    sharedRegionApp.out \
    memmgrserver.out \
    notifyping.out \
    ducati_load.out \
    procMgrApp.out \
    slpmresources.out \
    slpmtransport.out \
    utilsApp.out \
    libd2cmap \
    libomap_mm_library_jni \
    libtimemmgr

# Filesystem management tools
PRODUCT_PACKAGES += \
    make_ext4fs \
    setup_fs

PRODUCT_PACKAGES += \
    libskiahwdec \
    libskiahwenc

PRODUCT_PACKAGES += \
    libstagefrighthw

# To set the Wifi MAC address from NV, and the softap stuff
PRODUCT_PACKAGES += \
    lib_driver_cmd_wl12xx \
    calibrator \
    hostapd \
    wpa_supplicant \
    libwpa_client \
    dhcpcd.conf \
    libhostapdcli \
    wifimac

#RIL
PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/system/lib/lge-ril.so \
    ro.telephony.ril_class=LGEInfineon

# Charger mode
PRODUCT_PACKAGES += \
    charger \
    charger_res_images

# Wifi Direct and WPAN
PRODUCT_PACKAGES += \
    ti_wfd_libs \
    ti-wpan-fw

# Bluetooth 
PRODUCT_PACKAGES += \
    uim-sysfs \
    libbt-vendor

# FM Radio
PRODUCT_PACKAGES += \
    FmRxApp \
    FmTxApp \
    FmService \
    libfmradio \
    fmradioif \
    com.ti.fm.fmradioif.xml 

# Still need to set english for audio init
PRODUCT_LOCALES += en_US

# sw vsync setting
#PRODUCT_PROPERTY_OVERRIDES += \
#    persist.hwc.sw_vsync=1

# General
PRODUCT_PROPERTY_OVERRIDES += \
    ro.crypto.state=unencrypted \
    ro.ksm.default=1 \
    ro.hdcp.support=2 \
    ro.service.start.smc=1 \
    dalvik.vm.jit.codecachesize=0 \
    ro.config.low_ram=true \
    persist.sys.root_access=1 \
    camera2.portability.force_api=1 \
    media.aac_51_output_enabled=true \
    hwui.render_dirty_regions=false \
    force_hw_ui=true

# Vold
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vold.switchablepair=/storage/sdcard0,/storage/sdcard1
    ro.additionalmounts=/storage/sdcard1


# adb has root
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.adb.secure=0 \
    ro.secure=0 \
    ro.allow.mock.location=1 \
    persist.sys.root_access=3 \
    ro.debuggable=1 \
    persist.sys.usb.config=mtp \
    ro.selinux=permissive 

# Don't preload EGL drivers in Zygote at boot time
PRODUCT_PROPERTY_OVERRIDES += \
	ro.zygote.disable_gl_preload=true

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := full_p920
PRODUCT_DEVICE := p920
PRODUCT_MODEL := LG-P920
PRODUCT_MANUFACTURER := LGE

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product-if-exists, vendor/lge/p920/p920-vendor.mk)
$(call inherit-product, device/common/gps/gps_eu.mk)
#$(call inherit-product-if-exists, device/lge/p920/s3d/s3d-products.mk)
$(call inherit-product-if-exists, hardware/ti/wpan/ti-wpan-products.mk)
$(call inherit-product, frameworks/native/build/phone-hdpi-512-dalvik-heap.mk)

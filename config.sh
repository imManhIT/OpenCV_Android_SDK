#!/bin/bash

# Android NDK (version 21.* < 22)
# cmake built-in Android SDK (version 3.10.* < 3.18)
export ANDROID_NDK=/Volumes/WORKS/Android/sdk/ndk/21.4.7075529
export ANDROID_SDK=/Volumes/WORKS/Android/sdk
export ANDROID_SDK_ROOT=/Volumes/WORKS/Android/sdk

#set android api level
ANDROID_NATIVE_API_LEVEL=26
ANDROID_SDK_TARGET=30

# add extra modules
EXTRA_MODULE_LIST=xfeatures2d

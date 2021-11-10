## OpenCV_Android_SDK

### Setup Enviroment:

This setup to build OpenCV Android SDK for Android 9 (28) and Android 10 (30) and build on Ubuntu 18.
- sdk cmdline-tools path: /mnt/d/Android-SDK/cmdline-tools/bin
- SDK path: `/mnt/d/Android-SDK/Linux`
- NDK path: `/mnt/d/Android-SDK/Linux/ndk/21.4.7075529`

1. Install JDK: `sudo apt install default-jdk`
2. Install [sdk cmdline-tools](https://developer.android.com/studio#command-tools "sdk cmdline-tools") and add sdk cmdline-tools path to `.bashrc`
3. Download SDK, NDK, CMake: `sdkmanager "platform-tools" "platforms;android-28" "platforms;android-30" "ndk;21.4.7075529" "cmake;3.10.2.4988404" "build-tools;28.0.3" "build-tools;30.0.3" --sdk_root=/mnt/d/Android-SDK/Linux`

### Download OpenCV sourcecode:

`./build.sh download` or `./build.sh download [version]`

### Build OpenCV Android SDK:
edit config file: config.sh
then run `./build.sh` or `./build.sh [version]`


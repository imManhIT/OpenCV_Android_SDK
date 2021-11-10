## OpenCV_Android_SDK

### Setup Enviroment:

This setup to build OpenCV Android SDK for Android 9 (28) and Android 10 (30) and build on Ubuntu 18.
SDK cmdline-tools path: `/mnt/d/Android-SDK/cmdline-tools/bin`
SDK path: `/mnt/d/Android-SDK/Linux`
NDK path: `/mnt/d/Android-SDK/Linux/ndk/21.4.7075529`

1. Install JDK: `sudo apt install default-jdk`
2. Install Python3 and set python as default: `update-alternatives --install /usr/bin/python python /usr/bin/python3 1`
3. Install [sdk cmdline-tools](https://developer.android.com/studio#command-tools "sdk cmdline-tools") and add sdk cmdline-tools path to `.bashrc`
4. Download SDK, NDK, CMake: `sdkmanager "platform-tools" "platforms;android-28" "platforms;android-30" "ndk;21.4.7075529" "cmake;3.10.2.4988404" "build-tools;28.0.3" "build-tools;30.0.3" --sdk_root=/mnt/d/Android-SDK/Linux`
5. Install config ccache: 

`sudo apt-get install -y ccache`

`export USE_CCACHE=1`

`ccache -M 50G`

### Download OpenCV sourcecode:

`./build.sh download`

### Build OpenCV Android SDK:
Edit config.sh file: set host_os, cpu core number, sdk & ndk path, gradle version, extra module

Then run `./build.sh` or `./build.sh [version]`

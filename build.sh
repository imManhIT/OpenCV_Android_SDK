#!/bin/bash

clear

WORD_DIR=${PWD}
BUILD_DIR=${WORD_DIR}/build

# Android NDK (version 21.* < 22)
# cmake built-in Android SDK (version 3.10.* < 3.18)
export ANDROID_NDK=/Volumes/WORKS/Android/sdk/ndk/21.4.7075529
export ANDROID_SDK=/Volumes/WORKS/Android/sdk

SOURCE_DIR="${WORD_DIR}/opencv"
EXTRA_MODULE_SOURCE="${WORD_DIR}/opencv_contrib"
EXTRA_MODULE_LIST=xfeatures2d

download_source() {
	if [[ $1 == "" ]]; 
	then
		echo git clone https://github.com/opencv/opencv.git $SOURCE_DIR
		git clone https://github.com/opencv/opencv_contrib.git $EXTRA_MODULE_SOURCE
	else
		git clone -b $1 --single-branch https://github.com/opencv/opencv.git $SOURCE_DIR
		git clone -b $1 --single-branch https://github.com/opencv/opencv_contrib.git $EXTRA_MODULE_SOURCE
	fi
}

set_version() {

	echo "Config build version: ${1}"

	cd $SOURCE_DIR
	git reset --hard HEAD
	git pull
	git checkout $1

	cd $EXTRA_MODULE_SOURCE
	git reset --hard HEAD
	git pull
	git checkout $1

	cd $BUILD_DIR
}

set_extra_module() {

	echo "Config extra modules: ${EXTRA_MODULE_LIST}"

	if [[ ! $EXTRA_MODULE_LIST = "all" ]]; 
	then
		cd ${EXTRA_MODULE_SOURCE}/modules
		mkdir ${EXTRA_MODULE_SOURCE}/tmp

		for i in ${EXTRA_MODULE_LIST//,/ }
		do
			mv -f $i ${EXTRA_MODULE_SOURCE}/tmp/
		done

		rm -fR *
		mv -f ${EXTRA_MODULE_SOURCE}/tmp/* ${EXTRA_MODULE_SOURCE}/modules/
		rm -fR ${EXTRA_MODULE_SOURCE}/tmp/
	fi
}

run_build() {

	if [[ ! $1 == "" ]]; then
		set_version $1
	fi

	set_extra_module

	if [[ -d $BUILD_DIR ]]; then
		rm -fR $BUILD_DIR
	fi
	mkdir $BUILD_DIR

	echo python "${SOURCE_DIR}/platforms/android/build_sdk.py" --debug_info --no_samples_build --extra_modules_path "${EXTRA_MODULE_SOURCE}/modules" --config "../build.config.py"
	python "${SOURCE_DIR}/platforms/android/build_sdk.py" --debug_info --no_samples_build --extra_modules_path "${EXTRA_MODULE_SOURCE}/modules" --config "../build.config.py" >> build.log
	
}

case "$1" in
	download)
		# build.sh download [version]
		# build.sh download 4.5.1
		download_source $2
		;;
	version)
		# build.sh version [version]
		# build.sh version 4.5.1
		set_version $2
		;;
	setmodule)
		set_extra_module
		;;
	build)
		# build.sh build [version]
		# build.sh build 4.5.1
		run_build $2
		;;
	test)
		echo "Run test..."
		;;
esac



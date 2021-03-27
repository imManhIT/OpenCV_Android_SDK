#!/bin/bash

clear

WORD_DIR=${PWD}
SOURCE_DIR="${WORD_DIR}/opencv"
EXTRA_MODULE_SOURCE="${WORD_DIR}/opencv_contrib"
BUILD_DIR=${WORD_DIR}/build

source ${WORD_DIR}/config.sh

download_source() {
	git clone https://github.com/opencv/opencv.git $SOURCE_DIR
	git clone https://github.com/opencv/opencv_contrib.git $EXTRA_MODULE_SOURCE
}

set_version() {

	echo "Config source version: ${1}"

	cd $SOURCE_DIR
	git reset --hard HEAD
	git pull
	git checkout $1

	cd $EXTRA_MODULE_SOURCE
	git reset --hard HEAD
	git pull
	git checkout $1
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

	if [[ ! -d $SOURCE_DIR ]]; then
		download_source
	fi

	if [[ ! $1 == "" ]]; then
		set_version $1
	fi

	set_extra_module

	cd $WORD_DIR

	cp -f build.config.py.example build.config.py
	cp -f build_sdk.py.example build_sdk.py

	if [[ ! $1 == "master" ]]; then
		cp -f gradle-wrapper.properties ${SOURCE_DIR}/platforms/android/gradle-wrapper/gradle/wrapper/gradle-wrapper.properties
	fi

	case "$HOST_OS" in
		macos)
			sed -i "" "s/ANDROID_SDK_TARGET\=[0-9]*\,/ANDROID_SDK_TARGET\=${ANDROID_SDK_TARGET}\,/g" build.config.py
			sed -i "" "s/\, [0-9]*\, cmake_vars/\, ${ANDROID_NATIVE_API_LEVEL}\, cmake_vars/g" build.config.py
			sed -i "" "s/@GRADLE_PLUGIN@/${ANDROID_GRADLE_PLUGIN_VERSION}/g" build.config.py
			sed -i "" "s/@GRADLE_VERSION@/${GRADLE_VERSION}/g" build.config.py
			sed -i "" "s/@GRADLE_VERSION@/${GRADLE_VERSION}/g" ${SOURCE_DIR}/platforms/android/gradle-wrapper/gradle/wrapper/gradle-wrapper.properties
			sed -i "" "s/\"-j[0-9]*\"/\"-j${CPU_CORE_NUMBER}\"/g" ${WORD_DIR}/build_sdk.py
			;;
		linux)
			sed -i "s/ANDROID_SDK_TARGET\=[0-9]*\,/ANDROID_SDK_TARGET\=${ANDROID_SDK_TARGET}\,/g" build.config.py
			sed -i "s/\, [0-9]*\, cmake_vars/\, ${ANDROID_NATIVE_API_LEVEL}\, cmake_vars/g" build.config.py
			sed -i "s/@GRADLE_PLUGIN@/${ANDROID_GRADLE_PLUGIN_VERSION}/g" build.config.py
			sed -i "s/@GRADLE_VERSION@/${GRADLE_VERSION}/g" build.config.py
			sed -i "s/@GRADLE_VERSION@/${GRADLE_VERSION}/g" ${SOURCE_DIR}/platforms/android/gradle-wrapper/gradle/wrapper/gradle-wrapper.properties
			sed -i "s/\"-j[0-9]*\"/\"-j${CPU_CORE_NUMBER}\"/g" ${WORD_DIR}/build_sdk.py
			;;
	esac

	cp -f build_sdk.py ${SOURCE_DIR}/platforms/android/build_sdk.py

	if [[ -d $BUILD_DIR ]]; then
		rm -fR $BUILD_DIR
	fi
	mkdir $BUILD_DIR
	cd $BUILD_DIR

	if [[ $DEBUG_INFO == "ON" ]]; 
	then
		echo python "${SOURCE_DIR}/platforms/android/build_sdk.py" --debug_info --no_samples_build --extra_modules_path "${EXTRA_MODULE_SOURCE}/modules" --config "../build.config.py"
		python "${SOURCE_DIR}/platforms/android/build_sdk.py" --debug_info --no_samples_build --extra_modules_path "${EXTRA_MODULE_SOURCE}/modules" --config "../build.config.py"
	else
		echo python "${SOURCE_DIR}/platforms/android/build_sdk.py" --no_samples_build --extra_modules_path "${EXTRA_MODULE_SOURCE}/modules" --config "../build.config.py"
		python "${SOURCE_DIR}/platforms/android/build_sdk.py" --no_samples_build --extra_modules_path "${EXTRA_MODULE_SOURCE}/modules" --config "../build.config.py"
	fi
	
}

case "$1" in
	download)
		# ./build.sh download
		download_source
		;;
	*)
		# ./build.sh [version]
		# ./build.sh 4.5.1
		run_build $1
		;;
	test)
		echo "Run test..."
		;;
esac


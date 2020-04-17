@echo off cls
REM *NOTE* Change these based on 
SET SOIL_DIR=
::SET OUTPUT_DIR=assimp-build-armeabi-v7a
SET OUTPUT_DIR=soil-build-arm64v8a
SET ANDROID_PATH=D:\android-sdk-windows
SET NDK_PATH=D:\android-sdk-windows\ndk\20.1.5948944
::SET NDK_TOOLCHAIN=%~dp0android-toolchain-24-llvm-armeabi-v7a 
SET NDK_TOOLCHAIN=%~dp0android-toolchain-24-llvm-arm64v8a
SET CMAKE_TOOLCHAIN=%NDK_PATH%\build\cmake\android.toolchain.cmake
SET CMAKE_PATH=%ANDROID_PATH%\cmake\3.10.2.4988404
REM *NOTE* Careful if you don't want rm -rf, I use it for testing purposes.
rm -rf %OUTPUT_DIR%
mkdir %OUTPUT_DIR%

REM pushd doesn't seem to work ):< 
cd %OUTPUT_DIR%
if not defined ORIGPATH set ORIGPATH=%PATH%
SET PATH=%CMAKE_PATH%\bin;%ANDROID_PATH%\tools;%ANDROID_PATH%\platform-tools;%ORIGPATH%
cmake.exe ^
        -GNinja ^
        -DCMAKE_TOOLCHAIN_FILE=%CMAKE_TOOLCHAIN% ^
        -DANDROID_NDK=%NDK_PATH% ^
        -DCMAKE_MAKE_PROGRAM=%CMAKE_PATH%\bin\ninja.exe ^
        -DCMAKE_BUILD_TYPE=Release ^
        ::-DANDROID_ABI="armeabi-v7a" ^
		-DANDROID_ABI="arm64-v8a" ^
        -DANDROID_NATIVE_API_LEVEL=24 ^
        -DANDROID_FORCE_ARM_BUILD=TRUE ^
        -DCMAKE_INSTALL_PREFIX=install ^
        -DANDROID_STL=c++_static ^
        -DCMAKE_CXX_FLAGS=-Wno-c++11-narrowing ^
        -DANDROID_TOOLCHAIN=clang ^
		::-DBUILD_SHARED_LIBS=OFF ^
        ../%SOIL_DIR%
cmake.exe --build .
cd ..
pause
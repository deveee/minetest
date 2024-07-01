#!/bin/bash -e

. ./sdk.sh

export DEPS_ROOT=$(pwd)

if [ ! -d irrlicht-src ]; then
	wget https://downloads.sourceforge.net/irrlicht/irrlicht-1.8.5.zip
	unzip irrlicht-1.8.5.zip
	mv irrlicht-1.8.5 irrlicht-src
	rm -f irrlicht-1.8.5.zip
	cd irrlicht-src
	git apply ../irrlicht.diff
	cd ..
fi

cd irrlicht-src/source/Irrlicht

CPPFLAGS="$CPPFLAGS \
          -DNO_IRR_USE_NON_SYSTEM_JPEG_LIB_ \
          -DNO_IRR_USE_NON_SYSTEM_LIB_PNG_ \
          -DNO_IRR_USE_NON_SYSTEM_ZLIB_ \
          -DNO_IRR_COMPILE_WITH_BZIP2_ \
          -DNO_IRR_COMPILE_WITH_MY3D_LOADER_ \
          -DNO_IRR_COMPILE_WITH_OGLES2_ \
          -DNO_IRR_COMPILE_WITH_DIRECT3D_9_ \
          -DNO_IRR_COMPILE_WITH_DIRECT3D_8_ \
          -I$DEPS_ROOT/zlib/include \
          -I$DEPS_ROOT/libjpeg/include \
          -I$DEPS_ROOT/libpng/include" \
CXXFLAGS="$CXXFLAGS -std=gnu++17" \
make staticlib_win32 -j${NPROC} NDEBUG=1

# update `include` folder
rm -rf ../../../irrlicht/include
mkdir -p ../../../irrlicht/include
cp -a ../../include ../../../irrlicht
# update lib
rm -rf ../../../irrlicht/lib
mkdir -p ../../../irrlicht/lib
cp ../../lib/Win32-gcc/libIrrlicht.a ../../../irrlicht/lib

echo "Irrlicht build successful"

#!/bin/sh
export KERNELDIR=`readlink -f .`
. ~/AGNi_stamp_STOCK.sh
#. ~/gcc-linaro-5.3-2016.02_arm-gnueabi.sh
#. ~/gcc-5.3-uber_arm-eabi.sh
. ~/gcc-6.0-uber_arm-eabi.sh

export ARCH=arm

if [ ! -f $KERNELDIR/.config ];
then
  make defconfig psn_n7105_new_defconfig
fi

. $KERNELDIR/.config

mv .git .git-halt

cd $KERNELDIR/
make -j3 || exit 1

mkdir -p $KERNELDIR/BUILT_N7105/lib/modules

rm $KERNELDIR/BUILT_N7105/lib/modules/*
rm $KERNELDIR/BUILT_N7105/zImage

find -name '*.ko' -exec cp -av {} $KERNELDIR/BUILT_N7105/lib/modules/ \;
${CROSS_COMPILE}strip --strip-unneeded $KERNELDIR/BUILT_N7105/lib/modules/*
cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/BUILT_N7105/

mv .git-halt .git

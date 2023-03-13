# Download base image ubuntu 20.04
FROM ubuntu:20.04 as uboot

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update

# Install packages
RUN apt install -y build-essential git libssl-dev
RUN apt install -y libc6-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev bison flex bc swig
RUN apt install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
RUN apt install -y gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
RUN apt install -y gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu
RUN apt install -y device-tree-compiler
RUN apt install -y curl wget
RUN apt install -y python3 python3-pip
RUN apt install -y zip unzip

WORKDIR /work


ENV ARCH=arm
ENV CC=aarch64-linux-gnu-

RUN git clone https://github.com/ARM-software/arm-trusted-firmware.git && \
    cd arm-trusted-firmware/ && \
    make CROSS_COMPILE=${CC} realclean && \
    make CROSS_COMPILE=${CC} PLAT=sun50i_h6 DEBUG=1
ENV BL31=/work/arm-trusted-firmware/build/sun50i_h6/debug/bl31.bin

ENV SCP=/dev/null

RUN git clone https://github.com/u-boot/u-boot
RUN cd /work/u-boot && \
    make distclean 

COPY orangepi_lite2_defconfig /work/u-boot/configs
COPY sun50i-h6-orangepi-lite2.dts /work/u-boot/arch/arm/dts/sun50i-h6-orangepi-lite2.dts

RUN cd /work/u-boot && \
    make CROSS_COMPILE=${CC} distclean && \
    make CROSS_COMPILE=${CC} orangepi_lite2_defconfig && \
	make CROSS_COMPILE=${CC} BL31=${BL31} SCP=${SCP}

# Clean Distro
FROM ubuntu:20.04
COPY --from=uboot /work/u-boot/u-boot-sunxi-with-spl.bin /u-boot-sunxi-with-spl.bin

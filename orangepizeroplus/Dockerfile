# Download base image ubuntu 20.04
FROM ubuntu:20.04 as armtrustedfirmware

# LABEL about the custom image
LABEL maintainer="87017586495@hdfilm.kz"
LABEL version="0.1"
LABEL description="This is custom Docker Image for build Orange PI Zero Plus U-Boot SPI-boot image."

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update

# Install packages
RUN apt install -y build-essential git libssl-dev
RUN apt install -y libc6-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev bison flex bc
RUN apt install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
RUN apt install -y gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
RUN apt install -y gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu
RUN apt install -y device-tree-compiler
RUN apt install -y curl wget
RUN apt install -y python3 python3-pip plantuml 
RUN apt install -y zip unzip 

WORKDIR /work

RUN wget -c https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu.tar.xz
RUN tar xf gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu.tar.xz
ENV CC=/work/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu/bin/aarch64-linux-gnu-

RUN wget -c https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-x86_64-arm-eabi.tar.xz
RUN tar xf gcc-arm-8.3-2019.03-x86_64-arm-eabi.tar.xz
ENV M0_CROSS_COMPILE=/work/gcc-arm-8.3-2019.03-x86_64-arm-eabi/bin/arm-eabi-

RUN git clone https://github.com/ARM-software/arm-trusted-firmware.git && \
    cd arm-trusted-firmware/ && \
    make CROSS_COMPILE=${CC} realclean && \
    make CROSS_COMPILE=${CC} PLAT=sun50i_a64

# SPL compile
FROM ubuntu:20.04 as or1k

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update

RUN apt install -y build-essential git libssl-dev libmpfr-dev
RUN apt install -y libc6-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev bison flex bc swig
RUN apt install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
RUN apt install -y gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
RUN apt install -y gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu
RUN apt install -y device-tree-compiler
RUN apt install -y curl wget
RUN apt install -y python3 python3-pip
RUN apt install -y zip unzip 

WORKDIR /work
RUN wget https://musl.cc/or1k-linux-musl-cross.tgz && \
    tar zxvf or1k-linux-musl-cross.tgz

ENV PATH="${PATH}:/work/or1k-linux-musl-cross/bin"

ENV CROSS_COMPILE=or1k-linux-musl-

RUN ln -s /usr/lib/x86_64-linux-gnu/libmpfr.so.6 /usr/lib/x86_64-linux-gnu/libmpfr.so.4

RUN git clone https://github.com/crust-firmware/crust && \
    cd crust && \
    make orangepi_zero_plus_defconfig && \
    make scp 

# U-Boot compile 
FROM ubuntu:20.04 as uboot

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update

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

COPY --from=armtrustedfirmware /work/arm-trusted-firmware/build/sun50i_a64/release/bl31.bin /bl31.bin
COPY --from=or1k /work/crust/build/scp/scp.bin /scp.bin

ENV ARCH=arm
ENV CROSS_COMPILE=aarch64-linux-gnu-
ENV BL31=/bl31.bin
ENV SCP=/scp.bin

RUN git clone https://github.com/u-boot/u-boot
RUN cd /work/u-boot && \
    make distclean 

COPY config /work/u-boot/.config 
COPY sun50i-h5-orangepi-zero-plus.dts /work/u-boot/arch/arm/dts/sun50i-h5-orangepi-zero-plus.dts

RUN cd /work/u-boot && \
    make && \
    ls -al .

# Clean Distro
FROM ubuntu:20.04
COPY --from=uboot /work/u-boot/u-boot-sunxi-with-spl.bin /u-boot-sunxi-with-spl.bin

# simply use the result

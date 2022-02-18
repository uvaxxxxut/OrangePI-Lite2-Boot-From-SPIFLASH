# Download base image ubuntu 20.04
FROM ubuntu:20.04 as intermediate

# LABEL about the custom image
LABEL maintainer="87017586495@hdfilm.kz"
LABEL version="0.1"
LABEL description="This is custom Docker Image for build Orange PI PC U-Boot SPI-boot image."

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update

# Install packages
RUN apt install -y build-essential gcc-arm-linux-gnueabihf bc bison flex swig git python3 python3-distutils python3-dev libssl-dev python3-setuptools && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean
    
# Download git repository
RUN git clone https://github.com/u-boot/u-boot && \
    cd u-boot && \
    make distclean && \
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- orangepi_pc_defconfig && \
    ls -al /

# Copying dts file to source
COPY sun8i-h3-orangepi-pc.dts /u-boot/arch/arm/dts/sun8i-h3-orangepi-pc.dts
COPY config /u-boot/.config

# Make image
RUN cd u-boot && \
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- && \
    cp ./u-boot-sunxi-with-spl.bin /output

FROM ubuntu
COPY --from=intermediate /u-boot/u-boot-sunxi-with-spl.bin /u-boot-sunxi-with-spl.bin

# simply use the result

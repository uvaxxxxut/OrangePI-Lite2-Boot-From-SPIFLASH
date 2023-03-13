# Small howto

# For Orange Pi Lite 2 boards
## Build docker
```
cd orangepilite2
docker build \
    -t uboot_builder .
```

## Copy u-boot spi image 
```
cd orangepilite2
docker run --rm \
    --mount type=bind,source="$(pwd)"/output,target=/output \
    uboot_builder \
    cp /u-boot-sunxi-with-spl.bin /output

ls -al ./output
```

# For Orange Pi PC boards
## Build docker
```
cd orangepipc
docker build \
    -t uboot_builder .
```

## Copy u-boot spi image 
```
cd orangepipc 
docker run --rm \
    --mount type=bind,source="$(pwd)"/output,target=/output \
    uboot_builder \
    cp /u-boot-sunxi-with-spl.bin /output

ls -al ./output
```

# For Orange Pi Zero Plus boards
## Build docker
```
cd orangepizeroplus
docker build \
    -t uboot_builder .
```

## Copy u-boot spi image 
```
cd orangepizeroplus
docker run --rm \
    --mount type=bind,source="$(pwd)"/output,target=/output \
    uboot_builder \
    cp /u-boot-sunxi-with-spl.bin /output

ls -al ./output
```



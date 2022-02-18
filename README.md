# Small howto

## Build docker
```
docker build \
    -t uboot_builder .
```

## Copy u-boot spi image 
```
docker run --rm \
    --mount type=bind,source="$(pwd)"/output,target=/output \
    uboot_builder \
    cp /u-boot-sunxi-with-spl.bin /output

ls -al ./output
```

# Run Atlas in docker

We use another repo to build and show how to build the apache-atlas docker image. In this tutorial, we only show how
to create a container with the given docker image.


## Quick start

```shell
docker run -d \
    -p 21000:21000 \
    --name atlas \
    sburn/apache-atlas
```


## Use a custom conf folder

```shell
docker run -d \
    -v /home/pliu/Documents/docker-atlas/conf:/apache-atlas/conf \
    -p 21000:21000 \
    --name atlas-pengfei \
    atlas:v2.3.0
```

## Use a persistent docker volume to store atlas data

```shell
docker volume create atlas-data

docker volume list

# 
docker run --detach \
    -v /home/pliu/Documents/docker-atlas/conf:/apache-atlas/conf \
    -v atlas-data:/apache-atlas/data \
    -p 21000:21000 \
    --name atlas-pengfei \
    atlas:v2.3.0
```
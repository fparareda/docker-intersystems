# InterSystems Docker image

This repository aims to create the docker base image for Intersystems Cache.
This repository is a fork of ```daimor/docker-intersystems``` (Dmitry Maslennikov).


### Build the image:
```
docker build -t cache .
```

### Start the image:
```
docker run -d -p 1973:1972 -p 57773:57772 cache
```


### See the logs:
```
docker ps -a

docker logs <container-id>
```


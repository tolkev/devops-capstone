# TES Authoritative DNS


## Preriquisites
create container network
via docker
```
docker network create --ipv6 --subnet 2001:db8:0:0::/65 --subnet 10.90.0.0/17 main_v4_v6
```
via podman
```
podman network create --ipv6 --subnet 2001:db8:0:0::/65 --subnet 10.90.0.0/17 main_v4_v6
```

## Build the image
via podman
```
 podman-compose build
```

via docker
```
 docker-compose build
```

### Starting up the service via Docker or Podman


via podman
```
 podman-compose up -d
```

via docker
```
 docker-compose up -d
```

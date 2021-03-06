# alpine-jackett
Jackett Docker Image
Jackett works as a proxy server: it translates queries from apps (Sonarr, SickRage, CouchPotato, Mylar, etc) into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. This allows for getting recent uploads (like RSS) and performing searches. Jackett is a single repository of maintained indexer scraping & translation logic - removing the burden from other apps.[Jackett](https://github.com/Jackett/Jackett)

![jackett](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/jackett-banner.png)

## Usage

```
docker create --name=jackett \
-v <path to data>:/config \
-v <path to blackhole>:/downloads \
-v /etc/localtime:/etc/localtime:ro \
-e PGID=<gid> -e PUID=<uid> \
-e TZ=<timezone> \
-p 9117:9117 \
djavanargent/alpine-jackett
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `-p 9117` - the port(s)
* `-v /config` - where Jackett should store its config file.
* `-v /downloads` - Path to torrent blackhole
* `-e RUN_OPTS` - Optionally specify additional arguments to be passed. EG. `--ProxyConnection=10.0.0.100:1234`
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e TZ` for timezone EG. Europe/London

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it jackett /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application

The web interface is at `<your-ip>:9117` , configure various trackers and connections to other apps there.
More info at [Jackett](https://github.com/Jackett/Jackett).


## Info

* To monitor the logs of the container in realtime `docker logs -f jackett`.

* container version number 

`docker inspect -f '{{ index .Config.Labels "build_version" }}' jackett`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/jackett`

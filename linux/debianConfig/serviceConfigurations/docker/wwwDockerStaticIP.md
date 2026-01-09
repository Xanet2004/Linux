If we need to set a apache2 web page with static ip inside docker.

# WWW on docker configuration

```powershell title="docker network static ip"
docker network create \
  --subnet=192.168.42.0/24 \
  apache-net
```

```powershell title="dockerfile example - /home/user/containers/dockerfiles/Dockerfile"
FROM debian:bookworm-slim

LABEL maintainer "Xanet Zaldua <xzaldua@zalduabat.edu>"

RUN apt-get update && apt-get install -qqy apache2 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/usr/sbin/apachectl"]
CMD ["-D", "FOREGROUND"]
```

```powershell title="build docker image"
docker build -t apache2 /home/user/containers/dockerfiles
```

```powershell title="create folders"
mkdir -p /home/user/containers/apache2/{www/zalduabat,sites-available,sites-enabled,ssl}
```

```powershell title="cp files inside docker"
su - # root

cp /var/www/zalduabat/index.html /home/user/containers/apache2/www/zalduabat/
cp /etc/apache2/sites-available/zalduabat.conf /home/user/containers/apache2/sites-available/
cp /etc/apache2/sites-available/zalduabat-ssl.conf /home/user/containers/apache2/sites-available/
cp /etc/apache2/ssl/* /home/user/containers/apache2/ssl/
chown -R user:user /home/user/containers/apache2 # Change file owner to user
exit # exit from root
```

```powershell title="remove default page"
rm /home/user/containers/apache2/sites-enabled/000-default.conf
```

Activate pages and ssls

```powershell title="create needed links"
ln -s /home/user/containers/apache2/sites-available/zalduabat.conf /home/user/containers/apache2/sites-enabled/zalduabat.conf
ln -s /home/user/containers/apache2/sites-available/zalduabat-ssl.conf /home/user/containers/apache2/sites-enabled/zalduabat-ssl.conf
```

```powershell title="activate ssl modules and dependencies"
ln -s /home/user/containers/apache2/mods-available/ssl.conf /home/user/containers/apache2/mods-enabled/ssl.conf
ln -s /home/user/containers/apache2/mods-available/ssl.load /home/user/containers/apache2/mods-enabled/ssl.load
ln -s /home/user/containers/apache2/mods-available/setenvif.conf /home/user/containers/apache2/mods-enabled/setenvif.conf
ln -s /home/user/containers/apache2/mods-available/setenvif.load /home/user/containers/apache2/mods-enabled/setenvif.load
ln -s /home/user/containers/apache2/mods-available/mime.conf /home/user/containers/apache2/mods-enabled/mime.conf
ln -s /home/user/containers/apache2/mods-available/mime.load /home/user/containers/apache2/mods-enabled/mime.load
ln -s /home/user/containers/apache2/mods-available/socache_shmcb.load /home/user/containers/apache2/mods-enabled/socache_shmcb.load
```

```powershell title="run docker image"
docker run -d --rm --name apache2 \
  --hostname apache2-container \
  -v /home/user/containers/apache2/www:/var/www \
  -v /home/user/containers/apache2/sites-available:/etc/apache2/sites-available \
  -v /home/user/containers/apache2/sites-enabled:/etc/apache2/sites-enabled \
  -v /home/user/containers/apache2/ssl:/etc/apache2/ssl \
  -p 8000:80 \
  -p 44300:443 \
  apache2
  
  --
  
  docker run -d --rm --name apache2 \
  --hostname apache2-container \
  --net apache-net \
  --ip 192.168.42.30 \
  -v /home/user/containers/apache2/www:/var/www \
  -v /home/user/containers/apache2/ssl:/etc/apache2/ssl \
  -p 8000:80 \
  -p 44300:443 \
  apache2

```
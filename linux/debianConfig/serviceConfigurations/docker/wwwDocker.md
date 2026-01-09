If we need to set a apache2 web page inside docker.

# Installation

We can't download docker from the normal debian repositories. So we need to say where to install it.

```powershell title="installation - repository"
apt update
apt install apt-transport-https ca-certificates curl gnupg lsb-release ## Install needed packages to add the new repository from where we are going to install docker.
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```powershell title="installation - docker"
apt update
apt install docker-ce docker-ce-cli containerd.io
```

# Basic configuration example

```powershell title="add user to docker"
adduser user docker
```

```powershell title="change default network - /etc/docker/daemon.json"
{ # This is an internal network that docker will be using
	"bip": "172.18.0.1/24",
	"fixed-cidr": "172.18.0.0/24"
}
```

```powershell title="restart system"
reboot
```

## Create docker image

> Important
> Configure this as user, not root

```powershell title="create folders as user"
mkdir -p /home/user/containers/dockerfiles
mkdir -p /home/user/containers/apache2/www/zalduabat
mkdir /home/user/containers/apache2/ssl
```

```powershell title="create dockerfile - /home/user/containers/dockerfiles/Dockerfile"
FROM debian:bookworm-slim

LABEL maintainer "Xanet Zaldua <xzaldua@zalduabat.edu>"

RUN apt-get update && apt-get install -qqy apache2 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/usr/sbin/apachectl"]
CMD ["-D", "FOREGROUND"]
```

> Important
> We are creating a docker container for apache2 service.

```powershell title="generate image"
docker build -t apache2 /home/user/containers/dockerfiles
```

```powershell title="see images"
docker images
```

## Start container

```powershell title="run container"
docker run -d --rm --name apache2 apache2
```

```powershell title="running containers"
docker ps
```

```powershell title="stop container"
docker stop apache2
```
# WWW on docker configuration

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
```

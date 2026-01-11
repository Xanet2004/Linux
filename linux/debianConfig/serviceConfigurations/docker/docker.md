Docker is a platform designed to help developers build, share, and run container applications.
# Index
- [www on docker](/linux/debianConfig/serviceConfigurations/docker/wwwDocker.md)
- [www on docker with static ip](/linux/debianConfig/serviceConfigurations/docker/wwwDockerStaticIP.md)

# File index
- [/etc/service/example.conf](/linux/debianConfig/configurationFiles/etc/service/example.conf.md) – more info
- /etc/docker/daemon.json
- /home/user/containers/dockerfiles/Dockerfile

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
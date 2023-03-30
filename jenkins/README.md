

## Build

in [jenkins](./) of this project

```sh
DOCKER_BUILDKIT=1 docker build -t xiaoyao9184/kpt-jenkins-service:dev -f ./Dockerfile . 
```

```bat
SET DOCKER_BUILDKIT=1&& docker build -t xiaoyao9184/kpt-jenkins-service:dev -f ./Dockerfile . 
```

```powershell
SET DOCKER_BUILDKIT=1&& docker build -t xiaoyao9184/kpt-jenkins-service:dev -f ./Dockerfile . 
```

use mirror for download 

```powershell
docker build `
    --build-arg JENKINS_VERSION=2.346.3 `
    --build-arg JENKINS_UC=https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates `
    --build-arg JENKINS_UC_DOWNLOAD_URL=https://mirrors.tuna.tsinghua.edu.cn/jenkins `
    -t xiaoyao9184/kpt-jenkins-service:dev `
    -f ./Dockerfile . 
```

go inside container 

```sh
# bash for linux docker
docker run \
 --rm \
 -it \
 -e TZ=Asia/Hong_Kong \
 -v /etc/localtime:/etc/localtime:ro \
 -v /var/run/docker.sock:/var/run/docker.sock \
 --entrypoint="/bin/bash" \
 xiaoyao9184/kpt-jenkins-service:dev
```

```bat
:: windows batch for Docker Desktop Linux containers mode
docker run ^
 --rm ^
 -it ^
 -e TZ=Asia/Hong_Kong ^
 -v /etc/localtime:/etc/localtime:ro ^
 -v /var/run/docker.sock:/var/run/docker.sock ^
 --entrypoint="/bin/bash" ^
 xiaoyao9184/kpt-jenkins-service:dev
```

```powershell
# powershell for linux docker
docker run `
 --rm `
 -it `
 -e TZ=Asia/Hong_Kong `
 -v /etc/localtime:/etc/localtime:ro `
 -v /var/run/docker.sock:/var/run/docker.sock `
 --entrypoint="/bin/bash" `
 xiaoyao9184/kpt-jenkins-service:dev
```

then you can check ansible command

```sh
jenkins-plugin-cli --version
```

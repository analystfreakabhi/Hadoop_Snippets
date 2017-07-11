### Docker Install and setup : 

for windows 10 Home edition , use docker toolbox

https://www.docker.com/products/docker-toolbox

1) open Docker-QuickStart Terminal

1. Note IP : 192.168.99.100

2. Check running boxes : 

   ```shell
   docker ps -a 
   ```

3. docker-machine env

```shell
$ docker-machine env
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.101:2376"
export DOCKER_CERT_PATH="C:\Users\abhij\.docker\machine\machines\default"
export DOCKER_MACHINE_NAME="default"
export COMPOSE_CONVERT_WINDOWS_PATHS="true"
# Run this command to configure your shell:
# eval $("C:\Program Files\Docker Toolbox\docker-machine.exe" env)
```

4. docker-machine ip

```shell
$ docker-machine ip
192.168.99.101
```

5. Change  machine config : 

   **If you're on Windows**, please have a read here: [https://www.ibm.com/developerworks/community/blogs/jfp/entry/Using_Docker_Machine_On_Windows?lang=en](https://www.ibm.com/developerworks/community/blogs/jfp/entry/Using_Docker_Machine_On_Windows?lang=en) 
   As mentioned in the link, you can do:

   ```shell
   docker-machine rm default
   docker-machine create -d virtualbox --virtualbox-memory=6000 --virtualbox-cpu-count=2 default
   ```

   6. for docker-kafka container can be found in below : 

      https://github.com/Landoop/fast-data-dev

   7. **for windows run below :** 

```shell
# Docker for Mac >= 1.12, Linux, Docker for Windows 10
docker run --rm -it \
           -p 2181:2181 -p 3030:3030 -p 8081:8081 \
           -p 8082:8082 -p 8083:8083 -p 9092:9092 \
           -e ADV_HOST=127.0.0.1 \
           landoop/fast-data-dev

# Docker toolbox
docker run --rm -it \
          -p 2181:2181 -p 3030:3030 -p 8081:8081 \
          -p 8082:8082 -p 8083:8083 -p 9092:9092 \
          -e ADV_HOST=192.168.99.100 \
          landoop/fast-data-dev

# Kafka command lines tools
docker run --rm -it --net=host landoop/fast-data-dev bash

```
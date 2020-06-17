FROM ubuntu:latest

LABEL maintainer="https://openestate.org/"
LABEL version="1.0.0"
LABEL description="A HSQLDB server for multi user installations of OpenEstate-ImmoTool"

# copy source
COPY . /app/OpenEstate-Tool-Server

## -- BUILD
# install maven
RUN apt update && apt install wget maven -y && apt-get clean
WORKDIR /app/OpenEstate-Tool-Server/
# bad quiqufix for commons-daemon-1.1.0
RUN wget "https://archive.apache.org/dist/commons/daemon/binaries/windows/commons-daemon-1.1.0-bin-windows.zip" -P /app/OpenEstate-Tool-Server/temp/commons-daemon/
RUN bash ./mvn-release-quick.sh

# copy package into root instead of installing package because of systemd
RUN cp -rf ./package/debian-amd64/OpenEstate-ImmoServer/* /

# clenaing up
WORKDIR /app
RUN rm -rf /app/OpenEstate-Tool-Server/

# DB dir
VOLUME [ "/var/lib/OpenEstate-ImmoServer/data" ]
# DB port
EXPOSE 9001

CMD [ "bash", "/opt/OpenEstate-ImmoServer/bin/Start.sh" ]
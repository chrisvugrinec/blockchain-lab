FROM ubuntu
RUN apt-get -y update
RUN apt-get -y install git
RUN apt-get -y install openssl
RUN apt-get -y install nodejs
RUN apt-get -y install npm
RUN mkdir /labs && \
    ln -s /usr/bin/nodejs /usr/bin/node 
COPY instructions.txt /labs/
WORKDIR /labs/

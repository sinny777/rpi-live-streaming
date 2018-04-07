FROM hukam/pi3-base:v2
MAINTAINER Gurvinder Singh <contact@hukamtechnologies.com>

ENV BUILD_VERSION="V1"

USER root

# Updates S.O. and adds system required packages
RUN apt-get update && apt-get install -y wget tar \
    && rm -rf /var/lib/apt/lists/*

# Create a directory where our app will be placed
RUN mkdir -p /usr/src/app

#Change directory so that our commands run inside this new directory
WORKDIR /usr/src/app

COPY entrypoint.sh /usr/src/app
COPY build.sh /usr/src/app

RUN chmod +x /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/build.sh

RUN /usr/src/app/build.sh

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
CMD []

EXPOSE 5000

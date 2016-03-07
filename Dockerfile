# Need to use precise instead of trusty as the GIS packages don't exist for trusty yet.
FROM ubuntu:precise
MAINTAINER Saket<skate056@gmail.com>
 
RUN echo 'Starting to run'
RUN apt-get install -y python-software-properties software-properties-common
RUN add-apt-repository ppa:ubuntugis/ppa
RUN apt-get install -y curl vim

RUN apt-get update
RUN apt-get install -y gdal-bin

RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g topojson
RUN apt-get install -y unzip

WORKDIR /root
RUN mkdir -p maps
COPY *.zip /root/maps/
WORKDIR /root/maps
RUN unzip ne_10m_admin_0_map_subunits.zip
RUN unzip ne_10m_populated_places.zip
EXPOSE 9999
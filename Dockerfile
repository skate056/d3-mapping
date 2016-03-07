# Need to use precise instead of trusty as the GIS packages don't exist for trusty yet.
FROM ubuntu:precise
MAINTAINER Saket<skate056@gmail.com>

# Installed required packages and GDAL libraries 
RUN apt-get install -y python-software-properties software-properties-common
RUN add-apt-repository ppa:ubuntugis/ppa
RUN apt-get install -y curl vim unzip

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install -y nodejs

RUN apt-get install -y gdal-bin

RUN npm install -g topojson http-server

# Prepare map data
WORKDIR /root
RUN mkdir -p maps
COPY *.zip /root/maps/
WORKDIR /root/maps
RUN unzip ne_10m_admin_0_map_subunits.zip
RUN unzip ne_10m_populated_places.zip

RUN ogr2ogr \
  -f GeoJSON \
  -where "ADM0_A3 IN ('GBR', 'IRL')" \
  subunits.json \
  ne_10m_admin_0_map_subunits.shp

RUN ogr2ogr \
  -f GeoJSON \
  -where "ISO_A2 = 'GB' AND SCALERANK < 8" \
  places.json \
  ne_10m_populated_places.shp

RUN topojson \
  -o uk.json \
  --id-property SU_A3 \
  --properties name=NAME \
  -- \
  subunits.json \
  places.json

COPY index.html /root/maps
ENTRYPOINT http-server -p 8008
EXPOSE 8008
#!/bin/bash
set -e

# get the data from s3
sudo -u deploy curl 'https://s3.amazonaws.com/gds-public-readable-tarballs/mapit-postgres93-May2016.sql.gz' -o mapit.sql.gz
if ! echo "15d7e1eab81476511b96d773762ef6268d3d4289 mapit.sql.gz" | sha1sum -c -; then
  echo "SHA1 does not match downloaded file!"
  exit 1
fi

# drop the old db and bring up a new empty one
sudo -u postgres dropdb --if-exists mapit
sudo -u postgres createdb --owner mapit mapit
sudo -u postgres psql -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" mapit

# load up the downloaded data into this new db
zcat -f mapit.sql.gz | sudo -u postgres psql mapit

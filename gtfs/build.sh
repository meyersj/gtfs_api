#!/bin/bash

set -e
GTFS=gtfs.zip
GTFS_URL=http://developer.trimet.org/schedule/${GTFS}
BASEDIR=$(dirname $0)
DIR=/tmp/gtfs

# default 
rebuild_db="no"
db=""
db_user=postgres

# command line arguments and options
#   -r
#        drop existing database of the same name and rebuild
#   -d <database name> (required)
#       name of existing or new database to be used
#   -u <database user> default=postgres
#       postgres database user that will own any created database, tables or views
set -- $(getopt rd:u: "$@")
while [ $# -gt 0 ]
do
    case "$1" in
    (-r)
        rebuild_db="yes";;
    (-d) 
        db=$2;;
    (-u) 
        db_user=$2;;
esac
    shift
done

# exit with error if database name is not supplied
if [ "${db}" == "" ]; then
    echo "error: missing required argument '-d <database name>'"
    exit 1
fi

# rebuild postgres database and enable with postgis
# input:
#   $1 <database user>
#   $2 <database name>
#   $3 <sql directory>
function create_db {
    psql -U $1 -c "DROP DATABASE IF EXISTS $2;" -d postgres
    psql -U $1 -c "CREATE DATABASE $2;" -d postgres
    psql -U $1 -c "CREATE EXTENSION postgis;" -d $2
    psql -U $1 -f $3/create.sql -d $2
}

# download and unpack gtfs
function download_gtfs {
    mkdir -p ${DIR}
    rm -f ${DIR}/*.txt
    wget ${GTFS_URL} -O ${DIR}/${GTFS}
    unzip ${DIR}/${GTFS} -d ${DIR}
}

# delete and rebuild database
if [ "${rebuild_db}" == "yes" ]; then
    echo "info: rebuilding database"
    create_db ${db_user} ${db} ${BASEDIR}/sql
fi

download_gtfs
psql -U ${db_user} -f ${BASEDIR}/sql/create.sql -d ${db}
psql -U ${db_user} -f ${BASEDIR}/sql/insert.sql -d ${db}




set -e
#DB=gtfs
GTFS=gtfs.zip
BASEDIR=$(dirname $0)
DIR=${BASEDIR}/tmp_rebuild

set -- $(getopt abf: "$@")
while [ $# -gt 0 ]
do
    case "$1" in
    (-a)
        echo " a flag" 
        aflag=yes;;
    (-b) 
        echo " b flag"
        bflag=yes;;
    (-f) 
        echo "$2"
        flist="$flist $2"; shift;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*)  break;;
    esac
    shift
done

# download gtfs and unpack
mkdir -p ${DIR}
#wget http://developer.trimet.org/schedule/${GTFS} -O ${DIR}/${GTFS}
#unzip ${DIR}/${GTFS} -d ${DIR}

# build sql database from gtfs


# rebuild database
#psql -c "DROP DATABASE IF EXISTS ${db};" -d postgres
#psql -c "CREATE DATABASE ${db};" -d postgres
#psql -c "CREATE EXTENSION postgis;" -d ${db}

# OR

# update data
# TODO






#rm -r ${DIR}




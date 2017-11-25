#!/bin/bash
HERE=$(cd $(dirname $0); pwd)
$HERE/postgres.sh start
trap "$HERE/postgres.sh stop" SIGINT SIGTERM EXIT
PG_CONN=/tmp/mw-pg $@

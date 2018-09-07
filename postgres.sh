#!/bin/bash -e
TMPDIR=/tmp/mw-pg
PIDFILE=$TMPDIR/.s.PGSQL.5432.lock
start () {
    initdb -D $TMPDIR
    mkdir -p $TMPDIR/conf.d
    cat >/$TMPDIR/postgresql.conf <<EOF
    fsync = off
    listen_addresses = 'localhost'
    include_dir = 'conf.d'

    unix_socket_directories = '$TMPDIR'
EOF
    /usr/lib/postgresql/9.5/bin/postgres -D $TMPDIR &> $TMPDIR/stdout.log &
    postgres -D $TMPDIR &> $TMPDIR/stdout.log &
}

stop() {
    if [ -e "$PIDFILE" ]; then
        PID=`head -1 $PIDFILE`
        if [ -n "$PID" ]; then
            kill -9 $PID
        fi
    fi
    rm -rf $TMPDIR
}

if [ $# != 1 ]; then
    echo "need to specify start or stop as first argument"
    exit 1
fi

if [ $1 == "start" ]; then
    start
fi
if [ $1 == "stop" ]; then
    stop
fi

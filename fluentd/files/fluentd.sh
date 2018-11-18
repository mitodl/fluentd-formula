#!/bin/bash

PIDFILE=/var/run/fluentd.pid

start () {
    PID=`pgrep -f "$PSNAME"`
    if [ -z "$PID" ]; then
      if [ -f $PID_FILE ]; then rm -f $PID_FILE; fi
    else
      echo "fluentd already started."
      return -1
    fi
    echo -n "Starting fluentd: "
    fluentd --daemon $PID_FILE --config $CONF_FILE 
    echo "done."
}

stop () {
    if [ -e $PIDFILE ]
    then
        /usr/bin/pkill -F $PIDFILE
    else
        echo 'FluentD is not running'
    fi
}

reload () {
    if [ -e $PIDFILE ]
    then
        /usr/bin/pkill -SIGHUP -F $PIDFILE
    else
        echo 'FluentD is not running'
    fi
}

case $1 in
    start)
        start
        ;;
    stop)
        stop
        ;;
    reload)
        reload
        ;;
    restart)
        stop
        sleep 1
        start
        ;;
    *) exit 1
esac

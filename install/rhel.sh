#!/bin/bash

# Gearman worker manager

### BEGIN INIT INFO
# Provides:          gearman-manager
# Required-Start:    $network $remote_fs $syslog
# Required-Stop:     $network $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable gearman manager daemon
### END INIT INFO

# Source function library.
. /etc/rc.d/init.d/functions

DAEMON=/usr/local/bin/gearman-manager
PIDFILE=/var/run/gearman-manager.pid
LOGFILE=/var/log/gearman-manager.log
CONFIGDIR=/etc/gearman-manager
GEARMANUSER="gearmand"
PARAMS="-a -c ${CONFIGDIR}/config.ini -w ${CONFIGDIR}/workers"

RETVAL=0

start() {
        echo -n $"Starting gearman-manager: "
        # TODO: implement GearmanManager having a -u to change user for child procs
        daemon --pidfile=$PIDFILE $DAEMON \
            -P $PIDFILE \
            -l $LOGFILE \
            -d \
            $PARAMS
        RETVAL=$?
        echo
        return $RETVAL
}

stop() {
        echo -n $"Stopping gearman-manager: "
        killproc -p $PIDFILE $DAEMON
        RETVAL=$?
        echo
}

# See how we were called.
case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  status)
        status -p $PIDFILE $DAEMON
        RETVAL=$?
        ;;
  restart|reload)
        stop
        start
        ;;
  condrestart|try-restart)
        if status -p $PIDFILE $DAEMON >&/dev/null; then
                stop
                start
        fi
        ;;
  *)
        echo $"Usage: $prog {start|stop|restart|reload|condrestart|status|help}"
        RETVAL=3
esac

exit $RETVAL

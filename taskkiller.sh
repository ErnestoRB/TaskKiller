#!/bin/bash

PIDFILE="daemon.pid" # archivo donde se guardará el process ID
DAEMON="/usr/bin/taskkillerd.sh" # ruta del ejecutable
PIDFILE_PATH=${CONFIG_FOLDER}/${PIDFILE}
export CONFIG_FOLDER="/etc/taskkiller" # folder de configuracion
export CONFIG_FILE=${CONFIG_FOLDER}/procs.config

if [ ! -d $CONFIG_FOLDER ]; then
    mkdir $CONFIG_FOLDER # crear folder de configuración
fi

if [ ! -e $CONFIG_FILE ]
then
    echo "" >$CONFIG_FILE
fi

status() {
    if [ -s $PIDFILE_PATH ]
    then
        if [ $(ps -p $(cat $PIDFILE_PATH) | wc -l) -gt 1 ] # si se encuentra registro del proceso entonces está corriendo
        then
            return 0 # corriendo
        fi
        rm $PIDFILE_PATH # borrar archivo con el PID
    fi
    return 1 # apagado
}

start() {
    if [ ! -e $DAEMON ] # comprobar que realmente si exista
    then
        echo "No existe el demonio"
        exit 1
    fi
    if  ! status
    then
        eval "${DAEMON}"' & >/dev/null' # correr ejecutable en segundo plano y redireccionar salida a ninguna parte
        echo $! >$PIDFILE_PATH # guardar PID en el archivo pid
    else 
        echo "demonio ya corriendo"
    fi
}

stop() {
    if status
    then
        kill -9 `cat $PIDFILE_PATH`
        rm $PIDFILE_PATH
    else
        echo "demonio no corriendo"
    fi
}


case $1 in
    start)
        start
    ;;
    stop)
        stop
    ;;
    restart)
    ;;
    status)
        status
    ;;
    *)
        echo "Uso: [start | stop | restart | status]"
    ;;
esac
CONFIG_FOLDER="/etc/taskkiller" # folder de configuracion
PIDFILE="daemon.pid" # archivo donde se guardará el process ID
SERVICE="/usr/bin/demonio.sh" # ruta del ejecutable
PIDFILE_PATH=${CONFIG_FOLDER}/${PIDFILE}

if [ ! -d $CONFIG_FOLDER ]; then
    mkdir $CONFIG_FOLDER # crear folder de configuración
fi

status() {
    if [ -s $PIDFILE_PATH ]
    then
        if [ $(ps -p $(cat /etc/taskkiller/daemon.pid) | wc -l) -gt 1 ] # si se encuentra registro del proceso entonces está corriendo
        then
            return 0 # corriendo
        fi
    fi
    return 1 # apagado
}

start() {
    if [ ! -e $SERVICE ] # comprobar que realmente si exista
    then
        echo "No existe el servicio"
        exit 1
    fi
    if  ! status
    then
        eval "${SERVICE}"' & >/dev/null' # correr ejecutable en segundo plano y redireccionar salida a ninguna parte
        echo $! >$PIDFILE_PATH # guardar PID en el archivo pid
    else 
        echo "Servicio ya corriendo"
    fi
}

stop() {
    if status
    then
        kill -9 `cat $PIDFILE_PATH`
        rm $PIDFILE_PATH
    else
        echo "Servicio no corriendo"
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
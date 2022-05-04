FOLDER="/etc/taskkiller/" # folder de configuracion
PIDFILE="daemon.pid" # archivo donde se guardará el process ID
SERVICE="TaskKiller.sh" # nombre del ejecutable 

if [ ! -d FOLDER ]; then
    mkdir $FOLDER # crear folder de configuración
fi

status() {
    if [ -s ${FOLDER}${PIDFILE} ]
    then
        return 0 # corriendo
    else
        return 1 # apagado
    fi
}

start() {
    if [ ! -e "/usr/bin/${SERVICE}" ] # comprobar que realmente si exista
    then
        echo "No existe el servicio"
        exit 1
    fi
    if ! status
    then
        eval "${SERVICE}"' &'
        echo $! >${FOLDER}${PIDFILE}
    else 
        echo "Servicio ya corriendo"
    fi
}

stop() {
    if status
    then
        kill -9 `cat ${FOLDER}${PIDFILE}`
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
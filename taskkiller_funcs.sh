#!/bin/bash

log() {
	PREFIX="[LOG]"
	echo "${PREFIX}: $(date) -> $*"
}

logError() {
	PREFIX="[ERR]"
	echo "${PREFIX}: $(date) -> $*" >&2
}

guardarSnapshot() { # función que toma la información de todos los procesos en el sistema y las guarda en el
# archivo indicado
    if [ -z $1 ]
    then
        logError "No se proporcionó ningun archivo en donde guardar una instantanea!"
        return 1
    fi
	if [ ! -d $( dirname $1 ) ]; then
		mkdir -p $( dirname $1) # asegurarnos que la ruta del archivo exista!
	fi
	# "INSTANTANEA"
    # guardar información de procesos. la información se separa en columnas con "," como delimitador
    # se imprime: PID, CPU, MEM, COMMAND, RSS, USER, VIRT
    # sin encabezados para mejor manipulacion!
    ps -e -o "%p,%C," -o %mem -o ",%c," -o rss -o ",%U," -o size --no-headers >"$1"
    return 0
}

nombre() {
	echo "Inserte nombre del proceso: "
	read proceso
	idProceso=$(pidof $proceso)
	if [ -z "$idProceso" ] #si idProceso es nulo, no existe el proceso
	then
		echo "No existe un proceso con ese nombre"
	else
		echo "Se eliminara el proceso con ID siguiente(s): " $idProceso
		echo "¿Continuar? (s/n) "
		read opt
		if [ $opt = "s" ]
		then
			pkill $proceso
			echo "Se ha eliminado un proceso satisfactoriamente"
		else
			echo "Operacion cancelada"
		fi
	fi
	return 0
}

analizarSnapshots() {
    # que criterio tomar ?
    # CPU -> arriba de 50% ya es abusivo ?
    # MEM -> >50%?
    if [ $# -eq 0 ] # $# se refiere al numero de argumentos pasados al script
    then
       	logError "No se proporcionaron archivos de donde analizar la información del sistema"
        return 1
    fi
    summary_file="/tmp/${folder:-taskk}/summary"
    # cat $@ une toda la información de los procesos capturada por guardarSnapshot()
    # $@ se refiere a todos los argumentos pasados al programa
    cat $@ >$summary_file 2>/dev/null # limpiar archivo
    # uniq -dc agrupa las linea repetidas
    # genera una salida en campos con los procesos que en más de un archivo aparecieron, es decir
    # que durante n "iteraciones" de guardarSnapshot() estaban corriendo con más de 50% uso de MEMORIA
    cat $summary_file | awk -F"," '$3 >= 50 { print $1 } ' | sort | uniq -dc >$summary_file #| awk 'BEGIN{ OFS="," } { print $2,$1 }'
	while read veces id
	do
		if [ $veces -ge 5 ]
		then
			kill -9 $id
			log "Proceso $id parado ya que estuvo usando mucha memoria del sistema."
		fi
	done <$summary_file
}

observarSistema(){
	if [ -z "$snapshots" ]
	then
		logError "La variable snapshots no está definida"
		return 1
	fi
	while true # esto debería correr siempre!
	do
		for i in $snapshots
		do
			guardarSnapshot $i # guardar información 
			# ${var:-word} Si la variable var no está declarada o es nula ("") entonces usar word
			sleep ${t_save:-15s} # esperar para que las instantaneas estén separadas
			# 15 segundos por defecto si t_save no está definitida
		done
		# una vez terminado analizar que programas tuvieron un comportamiento raro en esos 10 minutos
		analizarSnapshots $snapshots
	done
}

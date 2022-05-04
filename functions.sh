guardarSnapshot() { # función que toma la información de todos los procesos en el sistema y las guarda en el
# archivo indicado
    if [ -z $1 ]
    then
        echo "No se proporcionó ningun archivo en donde guardar una instantanea!"
        return 1
    fi
    # guardar información de procesos. la información se separa en columnas con "," como delimitador
    # se imprime: PID, CPU, MEM, COMMAND, RSS, USER, VIRT
    # sin encabezados para mejor manipulacion!
    ps -e -o "%p,%C," -o %mem -o ",%c," -o rss -o ",%U," -o size --no-headers | cat >"$1"
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
    # MEM -> >70%?
    if [ $# -eq 0 ] # $# se refiere al numero de argumentos pasados al script
    then
        echo "No se proporcionaron archivos de donde analizar la información del sistema"
        return 1
    fi
    summary_file="/tmp/$folder/summary"
    # cat $@ une toda la información de los procesos capturada por guardarSnapshot()
    # $@ se refiere a todos los argumentos pasados al programa
    echo `cat $@` >$summary_file # limpiar archivo
    # uniq omite repeticiones en archivos ordenados
    # genera una salida en campos con los procesos que en más de un archivo aparecieron, es decir
    # que durante n "iteraciones" de guardarSnapshot() estaban corriendo con ma´s de 70% uso de CPU
    cat $summary_file | awk -F"," '$3 >= 70 { print $1 } ' | sort | uniq -dc
}

observarSistema(){
	if [ -z "$snapshots" ]
	then
		echo "La variable snapshots no está definida"
		return 1
	fi
	if [ ! -e "/tmp/$folder" ] # comprueba que exista folder de datos
	then
		mkdir "/tmp/$folder" # crear folder
 	else
		rm -f "/tmp/$folder/*" # borrar archivos de la recopilación pasada
	fi
	while true # esto debería correr siempre!
	do
		for i in $snapshots
		do
			guardarSnapshot $i # guardar información 
			# ${var:-word} Si la variable var no está declarada o es nula ("") entonces usar word
			sleep ${t_save:-15s} # esperar para que las instantaneas estén separadas
		done
		# una vez terminado analizarSnapshots que programas tuvieron un comportamiento raro en esos 10 minutos
		analizarSnapshots $snapshots
	done
}

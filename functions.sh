salvarInfo() { # función que toma la información de todos los procesos en el sistema y las guarda en el
# archivo indicado, pero en ruta /tmp
    if [ -z $1 ]
    then
        echo "Se debe especificar el archivo!"
        return 1
    fi
    # guardar información de procesos ordenada por consumo de memoria
    ps -e -o "%p,%C," -o %mem -o ",%c," -o rss -o ",%U," -o size --sort -rss | cat >"/tmp/$tmp_folder/$1.mem"
    # por cpu
    ps -e -o "%p,%C," -o %mem -o ",%c," -o rss -o ",%U," -o size --sort -%cpu | cat >"/tmp/$tmp_folder/$1.cpu"
    return 0
}

nombre(){
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

analizar() {
    # que criterio tomar ?
    # CPU -> arriba de 50% ya es abusivo ?
    # MEM -> >70%?
    if [ $# -eq 0 ]
    then
        echo "Proporciona al menos un archivo el cual analizar"
        return 1
    fi
    for i in $@  # se le dan los archivos que contienen la información del sistema a analizar
    do
    echo "0" #para no generar error de ejecucion
    done
}

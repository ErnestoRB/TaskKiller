salvarInfo() { # función que toma la información de todos los procesos en el sistema y las guarda en el
# archivo indicado
    if [ -z $1 ]
    then
        echo "Se debe especificar el archivo!"
        return 1
    fi
    # guardar información de procesos
    ps -e -o "%p,%C," -o %mem -o ",%c," -o rss -o ",%U," -o size | cat >"$1"
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

analizar() {
    # que criterio tomar ?
    # CPU -> arriba de 50% ya es abusivo ?
    # MEM -> >70%?
    if [ $# -eq 0 ]
    then
        echo "Proporciona al menos un archivo el cual analizar"
        return 1
    fi
    summary_file="/tmp/$tmp_foldername/summary"
    # cat $@ une toda la información de los procesos capturada por salvarInfo()
    echo `cat $@` >$summary_file # limpiar archivo
    # uniq omite repeticiones
    # p <- pid de procesos que consumen 70% o más de memoria
    for p in `cat $@ | awk -F"," 'NR>1 && $3 >= 70 { print $1 } ' | uniq `
    do
        echo "$p, $(cat $@ | grep $p | wc -l )" >>$summary_file # cuantas veces se encontró
    done
    # p <- pid de procesos que usan 50% o más de CPU
    # cat $@ | awk -F"," 'NR>1 && $2 >= 50 { print $1 } '
}

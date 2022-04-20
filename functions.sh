salvarInfo() { # función que toma la información de todos los procesos en el sistema y las guarda en el
# archivo indicado, pero en ruta /tmp
    if [ -z $1 ]
    then
        echo "Se debe especificar el archivo!"
        return 1
    fi
    ps -eo "%p,%C,%c," -o rss -o "%U," -o size | cat >"/tmp/$1"
    return 0
}

analizar() {
    # que criterio tomar ?
    # CPU -> arriba de 50% ya es abusivo ?
    # MEM -> >70%?
    for i in $@
    do
    done
}
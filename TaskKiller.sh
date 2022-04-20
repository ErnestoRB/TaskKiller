#!/bin/bash

# Comando que muestra el ID del proceso, el porcentaje de cpu usado, el comando (nombre de binario), tamaño de memoria usado en memoria
# fisica, el usuario y la cantidad de memoria usada"
# ps -eo "%p,%C,%c," -o rss -o "%U," -o size
# se puede usar el comando cut para poder filtrar por columnas
# Ya que están separados por comas (cada columna) se usaría el comando siguiente
# cut -d' ' -fn 
# donde "n" es nombre de campo a accesar

tmp_foldername="taskk"
file_prefix="taskkf-"

if [ ! -e "/tmp/$tmp_foldername" ]
then
	mkdir "/tmp/$tmp_foldername"
fi

source functions

while true
do
	
	for i in seq 1 10
	do
		salvarInfo "${file_prefix}${i}" # guardar información
		sleep 1m # esperar un minuto (que tan buena idea es?) 
	done
	# una vez terminado analizar que programa tuvieron un comportamiento extremista en esos 10 minutos

done

nombre(){
	echo "Inserte nombre del proceso: "
	read proceso
	idProceso=$(pidof $proceso)
	echo $idProceso
	if [ -z "$idProceso" ] #si idProceso es nulo, no existe el proceso
	then
		echo "No existe un proceso con ese nombre"
	else
		echo "Se eliminara el proceso con ID " $idProceso
		echo "¿Continuar? (s/n) "
		read opcion
		if [ $opcion = "s" ]
		then
			pkill $proceso
			echo "Se ha eliminado un proceso satisfactoriamente"
		else
			echo "Operacion cancelada"
		fi
	fi
}


clear
echo "¿Como deseas eliminar un proceso?"
echo "1) Por nombre"
echo "2) Limite de RAM"
echo "3) Limite de CPU"
echo "Inserte opcion:"
read opcion

case $opcion in 
	1)
		nombre
		;;
	2)
		;;
	3)
		;;
	*)
		echo "No es una opcion"
esac



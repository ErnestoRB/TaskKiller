#!/bin/bash

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



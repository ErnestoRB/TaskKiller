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
t_save="1m"

infoCheck=false #verifica si ya se hizo el backup de informacion de procesos

source functions.sh # cargar funciones para modularizar el código

valores="" # valores se refiere a los archivos en los cuales se va a guardar una instantánea del
# sistema para de ahí tomar decisiones
for i in seq 1 10 # generar 10 archivos
do
	if [ -z $valores ]
	then
		valores="/tmp/${tmp_foldername}/${file_prefix}${i}"
	else
		valores=" ${valores}/tmp/${tmp_foldername}/${file_prefix}${i}"
	fi
done

recopilarInfo(){ #funcion valida para opcion 2 y 3, no se hace al inicio por si el usuario desea solo borrar un proceso por nombre (asi no espera el tiempo de recopilacion)
	if [ ! -e "/tmp/$tmp_foldername" ] # comprueba que exista folder de datos
	then
		mkdir "/tmp/$tmp_foldername"
	fi
	while true
	do
		for i in valores
		do
			salvarInfo $i # guardar información 
			sleep $t_save # esperar para que las instantaneas estén separadas
		done
		# una vez terminado analizar que programas tuvieron un comportamiento raro en esos 10 minutos
		analizar $valores
		let infoCheck=true
	done
}

opcion=0

while [ $opcion -ne 4 ]
do
	clear
	echo "¿Como deseas eliminar un proceso?"
	echo "1) Por nombre"
	echo "2) Limite de RAM"
	echo "3) Limite de CPU"
	echo "4) Salir"
	echo "Inserte opcion:"
	read opcion

	case $opcion in 
		1)
			nombre
			sleep 3s
			;;
		2)
			echo "Verificando si hay informacion de procesos..."
			if [ "$infoCheck" = true ]
			then
				echo "Hay informacion sobre procesos!"
				#hacer lo que tenga que seguir
			else
				echo "Recopilaremos informacion de procesos, esto tardará un tiempo"
				recopilarInfo
			fi
			sleep 3s
			;;
		3)
			;;
		4)
			echo "Hasta luego"
			;;
		*)
			echo "No es una opcion"
			sleep 3s
	esac
done

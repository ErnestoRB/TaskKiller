folder="taskk"
file_prefix="taskkf-"
t_save="10s"
log_file="killer.log"

snapshots="" # snapshots se refiere a los archivos en los cuales se va a guardar una instantánea del
# sistema para de ahí tomar decisiones
for i in `seq 1 10` # generar 10 archivos
do
	if [ -z $snapshots ]
	then
		snapshots="/tmp/${folder}/${file_prefix}${i}"
	else
		snapshots="${snapshots} /tmp/${folder}/${file_prefix}${i}"
	fi
done

source functions.sh # cargar funciones para modularizar el código

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
			;;
		3)
			;;
		4)
			echo "Hasta luego"
			;;
		*)
			echo "No es una opcion válida"
			sleep 3s
	esac
done

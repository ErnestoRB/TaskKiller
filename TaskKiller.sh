tmp_foldername="taskk"
file_prefix="taskkf-"
t_save="10s"

infoCheck=false #verifica si ya se hizo el backup de informacion de procesos

source functions.sh # cargar funciones para modularizar el código

valores="" # valores se refiere a los archivos en los cuales se va a guardar una instantánea del
# sistema para de ahí tomar decisiones
for i in `seq 1 10` # generar 10 archivos
do
	if [ -z $valores ]
	then
		valores="/tmp/${tmp_foldername}/${file_prefix}${i}"
	else
		valores="${valores} /tmp/${tmp_foldername}/${file_prefix}${i}"
	fi
done

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
		5)
			recopilarInfo
			;;
		*)
			echo "No es una opcion"
			sleep 3s
	esac
done

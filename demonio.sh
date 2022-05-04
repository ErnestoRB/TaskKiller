folder="taskk"
file_prefix="taskkf-"
t_save="10s"
log_file="log"

. /usr/bin/functions.sh # igual que source

# sistema para de ahí tomar decisiones
for i in $(seq 1 10) # generar 10 archivos
do
	if [ -z "$snapshots" ] # las comillas son necesarias, si no se expande a varias cadenas... (por los espacios)
	then
		snapshots="/tmp/${folder}/${file_prefix}${i}"
	else
		snapshots="${snapshots} /tmp/${folder}/${file_prefix}${i}"
	fi
done

log_dir="/var/log/${folder}"

if [ ! -d $log_dir ]
then
    mkdir $log_dir
fi

observarSistema >${log_dir}/${log_file}
set -e

if [ $(id -u) -ne 0 ]
then
    echo "El script debe tener permisos de root!"
    exit 1
fi

if [ -e /usr/bin/demonio.sh ]; then
    rm -f /usr/bin/demonio.sh
fi

clear
echo "Instalando..."
cp demonio.sh /usr/bin
cp demonioHandler.sh /etc/init.d
chmod u+x /usr/bin/demonio.sh /etc/init.d/demonioHandler.sh
ln --symbolic /etc/init.d/demonioHandler.sh /etc/rc0.d/K99demonioHandler
ln --symbolic /etc/init.d/demonioHandler.sh /etc/rc6.d/K99demonioHandler
ln --symbolic /etc/init.d/demonioHandler.sh /etc/rc5.d/S99demonioHandler
ln --symbolic /etc/init.d/demonioHandler.sh /etc/rc5.d/S99demonioHandler
clear
echo "Hecho."
echo "Deseas iniciar el servicio ahora? s/n"
read res
if [ res = 'S' ]; then
    /usr/bin/demonioHandler.sh start
fi


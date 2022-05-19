set -e # hace que el script salga si alguna de las instrucciones retorna un valor 1

if [ $(id -u) -ne 0 ]
then
    echo "El script debe tener permisos de root!"
    exit 1
fi

daemonFile="taskkillerd.sh"
initFile="taskkiller.sh"
funcsFile="taskkiller_funcs.sh"

if [ -e /usr/bin/${initFile} ]; then
    rm -f /usr/bin/${initFile}
fi

clear
echo "Instalando..."
cp ${daemonFile} /usr/bin # la "d" se refiere a que es un proceso demonio
cp ${funcsFile} /usr/bin
cp ${initFile} /etc/init.d # ${initFile} debe siempre ir en /etc/init.d
chmod u+x /usr/bin/${daemonFile} /etc/init.d/${initFile}
ln -fs /etc/init.d/${initFile} /etc/rc0.d/K99${initFile} # runlevel de apagar
ln -fs /etc/init.d/${initFile} /etc/rc6.d/K99${initFile} # runlevel de reiniciar
ln -fs /etc/init.d/${initFile} /etc/rc5.d/S99${initFile} # runlevel por defecto X11
echo "Hecho."
echo "Deseas iniciar el servicio ahora? s/n"
read res
if [[ res =~ ^(sS)$ ]]; then
    /usr/bin/${initFile} start
    echo "Servicio iniciado! "
fi


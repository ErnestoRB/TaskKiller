#!/bin/bash
set -e # hace que el script salga si alguna de las instrucciones retorna un valor 1
if [ $(id -u) -ne 0 ]
then
    echo "El script debe tener permisos de root!"
    exit 1
fi

daemonFile="taskkillerd.sh" # la "d" se refiere a que es un proceso demonio
initFile="taskkiller.sh"  # ${initFile} debe siempre ir en /etc/init.d
funcsFile="taskkiller_funcs.sh"

. logUtils.sh

if [ -e /usr/bin/${initFile} ]; then
    rm -f /usr/bin/${initFile}
fi

clear
echo "Instalando..."
cp ${daemonFile} /usr/bin 
cp ${funcsFile} /usr/bin
cp ${initFile} /etc/init.d
chmod u+x /usr/bin/${daemonFile} /etc/init.d/${initFile}
echo -e "\e[1;1mDeseas que el demonio se inicie al iniciar tu computadora? s/n\e[0;1m"
read res
if [[ $res =~ ^[sS]$ ]]; then
    ln -fs /etc/init.d/${initFile} /etc/rc0.d/K99${initFile} # runlevel de apagar
    ln -fs /etc/init.d/${initFile} /etc/rc6.d/K99${initFile} # runlevel de reiniciar
    ln -fs /etc/init.d/${initFile} /etc/rc5.d/S99${initFile} # runlevel por defecto X11
    logSuccess 'Enlaces simbolicos en /etc/rc*.d/ creados.'
fi
logSuccess "Hecho."
echo -e "\e[1;1mDeseas iniciar el servicio ahora? s/n\e[0;1m"
read res
if [[ $res =~ ^[sS]$ ]]; then
    if /etc/init.d/${initFile} status
    then
        logError "Demonio ya iniciado!"
    else
        /etc/init.d/${initFile} start
        if /etc/init.d/${initFile} status
        then
            logSuccess "Demonio ahora esta corriendo"
        else
            logError "Algo malo sucedió. Abre un 'issue' en el repositorio de GitHub"
        fi
    fi
fi
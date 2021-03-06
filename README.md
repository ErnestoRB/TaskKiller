## TaskKiller

### Compatibilidad
Actualmente sólo ha sido probado en distribuciones Ubuntu 20.04 LTS, usando bash como shell.

### Como instalar

Pasos:
1. Clona el repositorio
2. Desplazate a la carpeta clonada
3. Escribir el siguiente comando en la terminal `chmod u+x install.sh && sudo bash ./install.sh`
4. Listo, si todo está bien el script te preguntará si deseas iniciar el servicio, digita 's' en caso afirmativo.
5. Para comprobar que el script esté funcionando usa `ps aux | grep taskkillerd.sh | wc -l`. La salida debe ser "2"
    - De manera alterna puedes usar `/etc/init.d/taskkiller.sh status && echo $?`. La salida debe ser "0"

### Explicación de funcionamiento

El punto base son las "instantaneas" del sistema. Una instantánea es un registro del estado de los procesos en algún momento en el tiempo.

TaskKiller está monitoreando el sistema, y una vez que recopila esa serie analiza el comportamiento de los procesos que se ejecutaron en ese lapso de tiempo. Actualmente solo se matan procesos que superen el consumo de 90% de la memoria por 50 segundos.

Además del monitoreo que hace TaskKiller se puede configurar un archivo localizado en /etc/taskkiller/procs.config, el cual por cada línea se puede especificar que procesos deben "morir" bajo ciertos criterios. Estos se especifican de la siguiente manera

| Criterio                                                                                     | Comando bajo el que se inicia el proceso | CPU% | MEM% | Formato    |
| -------------------------------------------------------------------------------------------- | ------------------- | ---- | ---- | ---------- |
| Eliminar el proceso que contenga la cadena 'hola'                                            | hola                |      |      | hola       |
| Eliminar el proceso que contenga la cadena 'hola' y que ocupe 60% del cpu                    | hola                | 60   |      | hola:60    |
| Eliminar el proceso que contenga la cadena 'adios' y que ocupe 90% de la memoria             | adios               | x    | 90   | hola:x:90  |
| Eliminar el proceso que contenga la cadena 'gracias' y que ocupe 60% de cpu o 70% de memoria | gracias             | 60   | 70   | hola:60:70 |

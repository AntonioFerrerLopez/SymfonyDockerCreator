#!/bin/bash
# -*- ENCODING: UTF-8 -*-

echo -e '\n'
echo -e '\e[1;37m ACCIÓN PREVENTIVA: DETENIENDO Y ELIMINANDO CONTENEDORES \e[0m \n'
docker stop php 
docker stop symfony-nginx
docker stop symfony-mariadb
docker stop symfony-adminer
docker stop symfony-rabbitmq
docker stop symfony-portainer

docker rm php 
docker rm symfony-nginx
docker rm symfony-mariadb
docker rm symfony-adminer
docker rm symfony-rabbitmq
docker rm symfony-portainer

echo -e '\n'
echo -e '\e[1;34m INICIANDO DESPLIEGE y comprobando el correcto despliegue de los contenedores base \e[0m \n'
docker-compose up -d --build 

if [ $? != 0 ];
then
   echo -e '\n \e[1;31m ERROR: FALLO AL DESPLEGAR. ABORTANDO \e[0m \n'
   exit 1
else
    echo -e '\n \e[1;32m DESPLIEGUE COMPLETADO \e[0m \n'
fi



echo -e '\e[1;34m COMPROBANDO REQUISITOS DE SYMFONY \e[0m \n'
docker exec php symfony check:requirements

if [ $? != 0 ];
then
    echo -e '\n \e[1;31m ERROR: FALLO AL COMPROBAR REQUISITOS DE SYMFONY . ABORTANDO \e[0m \n'
    exit 1
else
    echo -e '\n \e[1;32m REQUISITOS OK \e[0m \n'
fi


echo -e '\e[1;34m CREADO EL PROYECTO. Esto puede tardar un poco ... \e[0m \n'
docker exec php symfony new . 

if [ $? != 0 ];
then
   echo -e '\e[1;31m ERROR AL CREAR PROYECTO ¿la carpeta ./app está vacia? , Dispone de conexión a internet?  \e[0m \n'
    exit 1
   
else
  echo -e '\n \e[1;32m FIN DEL PROCESO DE CREACIÓN. listo !!!  revise la carpeta ./app \e[0m'
  echo -e '\e[0;36m Puede acceder al proyecto desde http:://localhost:8080 \e[0m \n'
fi


echo -e '\n'
echo -e '\e[1;37m PARANDO y ELIMIANADO SERVICIOS DE DOCKER  (ya se pueden emplear desde la aplicación)\e[0m \n'


docker stop php 
docker stop symfony-nginx
docker stop symfony-mariadb
docker stop symfony-adminer
docker stop symfony-rabbitmq
docker stop symfony-portainer

docker rm php 
docker rm symfony-nginx
docker rm symfony-mariadb
docker rm symfony-adminer
docker rm symfony-rabbitmq
docker rm symfony-portainer

echo -e '\n'
echo -e '\e[1;37m ELIMINANDO VOLUMEN DE MARIADB provisional\e[0m \n'
rm -R infrastructure/databases


echo -e '\n \e[1;34m PASANDO CONFIGURACIÓN DE CONTENEDORES A APLICACIÓN ./app \e[0m \n'

mkdir app/docker

cp docker-compose.yaml app/docker
if [ $? != 0 ];
then
   echo -e '\e[1;31m ERROR AL COPIAR: docker-compose.yaml a app/docker revise la configuración una vez termine el proceso CONTINUANDO... \e[0m \n'

else
  echo -e '\n \e[1;32m copiando valiables de entorno para docker \e[0m \n'
fi

cp .env app/docker
if [ $? != 0 ];
then
     echo -e '\e[1;31m ERROR AL COPIAR: .env a app/docker revise la configuración una vez termine el proceso CONTINUANDO... \e[0m \n'

else
  echo -e '\n \e[1;32m copiado correctamente \e[0m \n'
fi

echo -e '\n \e[1;34m COPIANDO CONFIGURACIÓN DE los contenedores \e[0m \n'
cp -r ./infrastructure/ app/docker/
if [ $? != 0 ];
then
     echo -e '\e[1;31m ERROR AL COPIAR CONFIGURACIÓN DE CONTENEDORES:  revise la configuración una vez termine el proceso CONTINUANDO... \e[0m \n'
else
  echo -e '\n \e[1;32m Configuración del contenedores copiada correctamente \e[0m \n'
fi
  




cat << "EOF"
          _ _,---._
       ,-','       `-.___
      /-;'               `._
     /\/          ._   _,'o \
    ( /\       _,--'\,','"`. )
     |\      ,'o     \'    //\
     |      \        /   ,--'""`-.
     :       \_    _/ ,-'         `-._
      \        `--'  /                )
       `.  \`._    ,'     ________,','
         .--`     ,'  ,--` __\___,;'
          \`.,-- ,' ,`_)--'  /`.,'
           \( ;  | | )      (`-/
             `--'| |)       |-/    Happy Coding
               | | |        | |
               | | |,.,-.   | |_
               | `./ /   )---`  )
              _|  /    ,',   ,-'
             ,'|_(    /-<._,' |--,
             |    `--'---.     \/ \
             |          / \    /\  \
           ,-^---._     |  \  /  \  \
        ,-'        \----'   \/    \--`.
       /            \              \   \
EOF

exit 0
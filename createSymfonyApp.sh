#!/bin/bash
# -*- ENCODING: UTF-8 -*-

echo -e '\n'
echo -e '\e[1;37m ACCIÓN PREVENTIVA: DETENIENDO CONTENEDORES \e[0m \n'
docker stop php 
docker stop symfony-mysql
docker stop symfony-nginx

echo -e '\n'
echo -e '\e[1;34m INICIANDO DESPLIEGE \e[0m \n'
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


echo -e '\e[1;34m CREADO EL PROYECTO \e[0m \n'
docker exec php symfony new . 

if [ $? != 0 ];
then
   echo -e '\e[1;31m ERROR AL CREAR PROYECTO ¿la carpeta ./app está vacia?  \e[0m \n'
    exit 1
   
else
  echo -e '\n \e[1;32m FIN DEL PROCESO DE CREACIÓN. listo !!!  revise la carpeta ./app \e[0m \n'
  echo -e '\e[0;36m Puede acceder al proyecto desde http:://localhost:8080 \e[0m \n'
fi

echo -e '\n \e[1;32m COPIANDO docker-composer.yaml con servicios básicos  en APP >> ./app \e[0m \n'
cp infrastructure/Symfony/docker-compose.yaml app/
if [ $? != 0 ];
then
   echo -e '\e[1;31m ERROR AL COPIAR: infrastructure/Symfony/docker-compose.yaml. CONTINUANDO CON EL PROCESO \e[0m \n'

else
  echo -e '\n \e[1;32m TODO LISTO \e[0m \n'
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
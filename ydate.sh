#!/bin/sh

# Si el shell no tiene argumentos, calculara el dia anterior al dia actual
if [ $# -eq 0 ]; then
   mes=`date +%m`
   dia=`date +%d`
   anio=`date +%Y`
   valido=1

# Si el shell tiene un argumento, se refiere a la fecha de la cual
# se calculara el dia previo
elif [ $# -eq 1 ]; then
   mes=`echo $1 | awk '{ printf(substr($0,5,2)) }'`
   dia=`echo $1 | awk '{ printf(substr($0,7,2)) }'`
   anio=`echo $1 | awk '{ printf(substr($0,1,4)) }'`
   valido=1

else
   echo "El numero de parametros es incorrecto. Use:"
   echo "$0"
   echo "o bien, use:"
   echo "$0 'fecha'"
   echo "donde 'fecha' es la fecha a calcular el dia previo"
   valido=0

fi

if [ $valido -eq 1 ]; then

   # Agregamos un cero al mes
   mes=`expr $mes + 0`

   # Restamos uno del dia actual
   dia=`expr $dia - 1`

   # Si el dia es cero, se calcula el ultimo dia del mes previo
   if [ $dia -eq 0 ]; then

      # Encontramos el mes previo
      mes=`expr $mes - 1`

      # Si el mes es cero, se trata del 31 de diciembre del anio previo
      if [ $mes -eq 0 ]; then
         mes=12
         dia=31
         anio=`expr $anio - 1`

      # Si el mes es distinto de cero, encontramos el ultimo dia del mes previo
      else
         case $mes in
         1|3|5|7|8|10|12) dia=31;;
         4|6|9|11) dia=30;;
         2)
            if [ `expr $anio % 4` -eq 0 ]; then
               if [ `expr $anio % 100` -eq 0 ]; then
                  if [ `expr $anio % 400` -ne 0 ]; then
                     dia=28
                  else
                     dia=29
                  fi
               else
                  dia=29
               fi
            else
               dia=28
            fi
         ;;
         esac
      fi
   fi

   if [ $dia -lt 10 ]; then
      dia=`echo "0$dia"`
   fi

   if [ $mes -lt 10 ]; then
      mes=`echo "0$mes"`
   fi

   echo "$anio$mes$dia"
fi



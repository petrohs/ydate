#!/bin/sh
ayuda () { echo '
#===============================================================================
#
#        SCRIPT:  ydate.sh
# 
#           USO:  ./ydate.sh [-d n] [aaaammdd]
# 
#   DESCRIPCION:  Obtiene la fecha anterior; por omision un dia, puede variar 
#                 con -d numero_dias
#      OPCIONES:  -d   Numero de dias atras
#  DEPENDENCIAS:  ---
#          BUGS:  ---
#         NOTAS:  0 es igual a 1 en parametro -d
#           URL:  http://petrohs.googlepages.com/ydate.sh
#     VERSIONES:  20090130 0.0.2 PetrOHS Se rediseño para aceptar el parametro
#                                -d a fin de recorrer fechas mas rapido.
#                 -------- 0.0.1 Carlos Aquiles Dominguez     Creacion. 
#===============================================================================
' | more;} 

#ayuda
 if [ "$1" = "-h" -o "$1" = "--help" -o "$1" = "--ayuda" ]
   then
    ayuda;
    exit 1;
  fi

#leyendo opciones de linea comandos
 while getopts d: _opciones
  do
   case "$_opciones" in
     d)
       _DIAr="$OPTARG";
       if [ -n "$_DIAr" -a $_DIAr = 0 ]; then _DIAr=1; fi;
      ;;
     *)
       ayuda;
       exit 2;
      ;;
    esac
  done
 shift `expr $OPTIND - 1`

#dias a recorrer si no lo definen
 if [ -z "$_DIAr" ]; then _DIAr=1; fi;

#fecha inicial
 if [ -z "$1" ]
  then
   _fecha=`date +%Y%m%d`;
  else
   _fecha=$1;

  fi

#ciclo para recorrer varios dias
 while [ $_DIAr -gt 0 ]
  do
   mes=` echo $_fecha | awk '{ printf(substr($0,5,2)) }'`;
   dia=` echo $_fecha | awk '{ printf(substr($0,7,2)) }'`;
   anio=`echo $_fecha | awk '{ printf(substr($0,1,4)) }'`;
#---   
   # Agregamos un cero al mes
    mes=`expr $mes + 0`
   # Restamos uno del dia actual
    dia=`expr $dia - 1`
   # Si el dia es cero, se calcula el ultimo dia del mes previo
    if [ $dia -eq 0 ]; 
     then
      # Encontramos el mes previo
       mes=`expr $mes - 1`
      # Si el mes es cero, se trata del 31 de diciembre del anio previo
       if [ $mes -eq 0 ]; 
        then
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
   #completar a dos digitos
    if [ $mes -lt 10 ]; then mes="0$mes"; fi;
    if [ $dia -lt 10 ]; then dia="0$dia"; fi;

   #Nuevos parametros
   _fecha=${anio}${mes}${dia};
   _DIAr=`expr $_DIAr - 1`;
  done

#"Compartir es bueno"
 echo $_fecha;
 exit 0;


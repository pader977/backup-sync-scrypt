#!/bin/bash

FECHA=$(date +%Y-%m-%d_%H-%M)
DESTINO_LOCAL="/backups_PIGM"
NOMBRE_ARCHIVO="backup_config_$FECHA.tar.gz"
USER_WIN="byteworks\\administrador"
IP_WIN="192.168.202.100"
RUTA_WIN="C:/backups_ubuserv"
APP_KEY="(CLAVE PUBLICA DE TU APP)"
APP_SECRET="(CLAVE PRIVADA DE TU APP)"
REFRESH_TOKEN="(TU TOKEN DE REFRESCO)"
#MAIN
#Comienza la compresión de archivos
echo "Comenzando compresión de archivos importantes"
tar -czf $DESTINO_LOCAL/$NOMBRE_ARCHIVO /etc/freeradius/3.0 /etc/squid /etc/suricata /etc/ufw
echo "Compresión de archivos importantes completada"

#---------------------------------------------------------------------------------------------
#Transferencia del archivo a Windows Server
echo "Transferiendo archivo a Windows Server"
scp $DESTINO_LOCAL/$NOMBRE_ARCHIVO "$USER_WIN@$IP_WIN:$RUTA_WIN"
#SCP con clave pública para automatizar
echo "Transferencia a Windows completada"

echo "Creacion del token de dropbox"
ACCESS_TOKEN=$(curl -s https://api.dropbox.com/oauth2/token \
    -u $APP_KEY:$APP_SECRET \
    -d grant_type=refresh_token \
    -d refresh_token=$REFRESH_TOKEN | jq -r '.access_token')
echo "Token de dropbox creado"

echo "Subiendo $NOMBRE_ARCHIVO a Dropbox"
curl -X POST https://content.dropboxapi.com/2/files/upload \
    --header "Authorization: Bearer $ACCESS_TOKEN" \
    --header "Dropbox-API-Arg: {\"autorename\":true,\"mode\":\"add\",\"path\":\"/Backups_UbuServ/$NOMBRE_ARCHIVO\"}" \
    --header "Content-Type: application/octet-stream" \
    --data-binary @$DESTINO_LOCAL/$NOMBRE_ARCHIVO
echo "Subida a Dropbox Completada"
find $DESTINO_LOCAL -type f -mtime +7 -name "*.tar.gz" -exec rm {} \;
echo "Copia de seguridad realizada con éxito: $NOMBRE_ARCHIVO"
echo "----------------------------------------------------------------------"


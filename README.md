# backup-sync-script
Un **script** escrito en **Bash** en el que se crea un archivo **.tar** comprimido con **gzip** de los directorios elegidos para posteriormete guardarse en el equipo, subirse a otro externo y a la nube de **Dropbox**.
Este script es útil para realizar **copias de seguridad en formato 3-2-1**

## REQUISITOS PREVIOS:
- Tener como mínimo un equipo adicional.

- Tener una aplicación en Dropbox
- Extraer el `APP_KEY` y `APP_SECRET` de nuestra aplicacion.  
Más información [aquí](https://www.dropbox.com/developers/documentation?_tk=pilot_lp&_ad=topbar1&_camp=docs)

- Tener dropbox configurado con automatización de la generación de Token.  
Más información [aquí](https://www.dropbox.com/developers/documentation/http/documentation#files-get_temporary_link)

- SSH configurado con clave pública al otro equipo para poder hacer el SCP

## VARIABLES A EDITAR:
- Debes editar las rutas del destino local
- Debes editar el Usuario de la otra máquina
- Debes editar la IP del otro equipo
- Debes editar el `APP_KEY`
- Debes editar el `APP_SECRET`
- Debes editar el `REFRESH_TOKEN`

## MODO DE FUNCIONAMEINTO
1. Se comprime una serie de carpetas o archivos en .tar.gz
2. Se utiliza Secure Copy Protocol / SCP con certificados para enviar el archivo comprimido a una máquina externa, ya sea un NAS u otro equipo
3. Se utiliza la API de Dropbox para sincronizar mediante el comando curl a nuestra nube
4. Se borran las copias que lleven más de una semana para no saturar el servidor con copias de seguridad antiguas

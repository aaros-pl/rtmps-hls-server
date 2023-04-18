#!/bin/sh

# Create fresh ssl directory
rm -rf /ssl/* && mkdir -p /ssl/self_signed

# Create a cert/key pair a Certificate Authroity cert if it doesn't already exist,
# otherwise we won't be able to generate a self signed cert and Nginx won't start properly.
echo -e "$(date +"%Y-%m-%d %H:%M:%S") INFO: Generating a Self Signing Certificate Authority..."
openssl genrsa -out /ssl/self_signed/RTMP-CA.key 2048
openssl req -x509 -new -nodes -key /ssl/self_signed/RTMP-CA.key -sha256 -days 1825 -subj '/CN=RTMP-Server-CA' -out /ssl/self_signed/RTMP-CA.crt
cp -fv /ssl/self_signed/RTMP-CA.crt /ssl/ &
>/dev/null
echo

# Generate the certifiate
SUBJ="/CN=$SSL_DOMAIN"
echo -e "$(date +"%Y-%m-%d %H:%M:%S") INFO: The generated certificate will be valid for: $SSL_DOMAIN"
openssl genrsa -out /ssl/self_signed/rtmp.key 2048
openssl req -new -key /ssl/self_signed/rtmp.key -subj $SUBJ -out /tmp/rtmp.csr
openssl x509 -req -in /tmp/rtmp.csr -CA /ssl/self_signed/RTMP-CA.crt -CAkey /ssl/self_signed/RTMP-CA.key -CAcreateserial -days 365 -sha256 -out /ssl/self_signed/rtmp.crt
echo

# Start Nginx
echo -e "$(date +"%Y-%m-%d %H:%M:%S") INFO: Starting Nginx!"
exec nginx -g "daemon off;"

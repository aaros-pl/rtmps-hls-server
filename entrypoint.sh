#!/bin/sh

set -e

function generate_root_cert
{
    echo -e "$(date +"%Y-%m-%d %H:%M:%S") INFO: Generating a Self Signing Certificate Authority..."
    openssl genrsa -out /ssl/self_signed/RTMP-CA.key 2048
    openssl req -x509 -new -nodes -key /ssl/self_signed/RTMP-CA.key -sha256 -days 1825 -subj '/CN=RTMP-Server-CA' -out /ssl/self_signed/RTMP-CA.crt
    cp -fv /ssl/self_signed/RTMP-CA.crt /ssl/
}

function generate_cert_from_root
{
    SUBJ="/CN=$SSL_DOMAIN"
    echo -e "$(date +"%Y-%m-%d %H:%M:%S") INFO: The generated certificate will be valid for: $SSL_DOMAIN"
    openssl genrsa -out /ssl/self_signed/rtmp.key 2048
    openssl req -new -key /ssl/self_signed/rtmp.key -subj $SUBJ -out /tmp/rtmp.csr
    openssl x509 -req -in /tmp/rtmp.csr -CA /ssl/self_signed/RTMP-CA.crt -CAkey /ssl/self_signed/RTMP-CA.key -CAcreateserial -days 365 -sha256 -out /ssl/self_signed/rtmp.crt
}

function generate_standalone_cert
{
    # Using IP Address, build temporary request file from template
    cp /cert_request.ext /ssl/temp.ext
    sed -i "s/__IP_ADDR__/$SSL_DOMAIN/g" /ssl/temp.ext
    openssl genrsa -out /ssl/self_signed/rtmp.key 2048
    openssl req -new -config /ssl/temp.ext -key /ssl/self_signed/rtmp.key -out /ssl/self_signed/rtmp.csr
    openssl x509 -req -days 300 -in /ssl/self_signed/rtmp.csr -extfile /ssl/temp.ext -extensions req_ext -signkey /ssl/self_signed/rtmp.key -out /ssl/self_signed/rtmp.crt
    rm /ssl/temp.ext
    # Print it to the console
    openssl x509 -in /ssl/self_signed/rtmp.crt -noout -text
    cat /ssl/self_signed/rtmp.crt
}

if [[ $SSL_DOMAIN == "" ]]; then
    echo "You need to set the SSL_DOMAIN env variable"
    exit 1
fi

# Create fresh ssl directory
rm -rf /ssl/* && mkdir -p /ssl/self_signed

# This was the original way of generating a root certificate and then generating indivudal certs from this
# for each domain.
# generate_root_cert
# generate_cert_from_root

generate_standalone_cert

echo -e "$(date +"%Y-%m-%d %H:%M:%S") INFO: Starting Nginx!"
exec nginx -g "daemon off;"

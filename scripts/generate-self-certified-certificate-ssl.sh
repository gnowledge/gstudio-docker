#!/usr/bin/env bash

# Ref : https://serversforhackers.com/self-signed-ssl-certificates


# Specify where we will install
# the clixserver certificate
GNAME="clixserver"
SSL_DIR="/etc/ssl/$GNAME"

if [[ -d /etc/ssl/$GNAME && -f /etc/ssl/$GNAME/$GNAME.crt  && -f /etc/ssl/$GNAME/$GNAME.csr && -f /etc/ssl/$GNAME/$GNAME.key ]]; then
    echo "Directory and files exists. Hence exiting the process.";
    echo "Directory : /etc/ssl/$GNAME ";
    echo "File : /etc/ssl/$GNAME/$GNAME.crt , /etc/ssl/$GNAME/$GNAME.csr and /etc/ssl/$GNAME/$GNAME.key";
    exit;
fi

# Set the wildcarded domain
# we want to use
DOMAIN="*.$GNAME"

# A blank passphrase
PASSPHRASE=""

# CSR variables meaning
#        C                      = Country
#        ST                     = Test State or Province
#        L                      = Test Locality
#        O                      = Organization Name
#        OU                     = Organizational Unit Name
#        CN                     = Common Name
#        emailAddress           = test@email.address

# Variables as it is prompted
# Country Name (2 letter code) [AU]:IN
# State or Province Name (full name) [Some-State]:Maharashtra
# Locality Name (eg, city) []:Mumbai
# Organization Name (eg, company) [Internet Widgits Pty Ltd]:Test
# Organizational Unit Name (eg, section) []:Test
# Common Name (e.g. server FQDN or YOUR name) []:test.org
# Email Address []:test@test.org

# Set our CSR variables
SUBJ="
C=IN
ST=Maharashtra
L=Mumbai
O=clix
OU=ss
CN=$GNAME
emailAddress=admin@$GNAME
"

# Create our SSL directory
# in case it doesn't exist
sudo mkdir -p "$SSL_DIR"

# Generate our Private Key, CSR and Certificate
sudo openssl genrsa -out "$SSL_DIR/$GNAME.key" 2048
sudo openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/$GNAME.key" -out "$SSL_DIR/$GNAME.csr" -passin pass:$PASSPHRASE
sudo openssl x509 -req -days 365 -in "$SSL_DIR/$GNAME.csr" -signkey "$SSL_DIR/$GNAME.key" -out "$SSL_DIR/$GNAME.crt"

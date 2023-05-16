#!/bin/bash

cat << EOF > cert.cnf
[CA_default]
copy_extensions = copy

[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
C = EN
ST = State
L = City
O = Organisation
CN = localhost

[v3_req]
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
IP.1 = 127.0.0.1
EOF



# CA Schlüssel und Zertifikat generieren
openssl req -new -x509 -keyout ca-key -out ca-cert

# Geheimen RSA Schlüssel und Zertifikatsanfrage generieren
openssl req -new -sha256 -newkey rsa:4096 -keyout localhost-rsa.key -out localhost-rsa.csr -extensions v3_req -config cert.cnf
# Die Zertifikatsanfrage kann nun signiert werden mit der zuvor generierten CA
openssl x509 -req -CA ca-cert -CAkey ca-key -in localhost-rsa.csr -out localhost-rsa.pem -days 365 -CAcreateserial -passin pass:changeit -extfile cert.cnf -extensions v3_req

# Zertifikatskette zusammenfügen
cat localhost-rsa.pem ca-cert > localhost-rsa.chain.pem
# Zertifikat zu KeyStore umwandeln
openssl pkcs12 -export -in localhost-rsa.chain.pem -inkey localhost-rsa.key -out keystore.p12 -name localhost -CAfile ca-cert -caname rootca

# CA Zertifikat in TrustStore umwandeln
keytool -import -file ca-cert -keystore truststore.p12 -alias ca-cert

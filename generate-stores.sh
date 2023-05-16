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



# Generate CA private key and certificate
openssl req -new -x509 -keyout ca-key -out ca-cert

# Generate RSA private key and Certificate Signing Request (CSR)
openssl req -new -sha256 -newkey rsa:4096 -keyout localhost-rsa.key -out localhost-rsa.csr -extensions v3_req -config cert.cnf
# Sign the CSR with the previously generated CA
openssl x509 -req -CA ca-cert -CAkey ca-key -in localhost-rsa.csr -out localhost-rsa.pem -days 365 -CAcreateserial -passin pass:changeit -extfile cert.cnf -extensions v3_req

# Zertifikatskette zusammenfügen
cat localhost-rsa.pem ca-cert > localhost-rsa.chain.pem
# Zertifikat zu KeyStore umwandeln
openssl pkcs12 -export -in localhost-rsa.chain.pem -inkey localhost-rsa.key -out keystore.p12 -name localhost -CAfile ca-cert -caname rootca

# CA Zertifikat in TrustStore umwandeln
keytool -import -file ca-cert -keystore truststore.p12 -alias ca-cert

mv keystore.p12 src/main/resources/
mv truststore.p12 src/main/resources/
######################
# Become a Certificate Authority
######################

# Generate private key
winpty openssl genrsa -des3 -out myCA.key 2048
# Generate root certificate
winpty openssl req -x509 -new -nodes -key myCA.key -sha256 -days 825 -out myCA.pem

######################
# Create CA-signed certs
######################

NAME=facebook.com # Use your own domain name
# Generate a private key
winpty openssl genrsa -out $NAME.key 2048
# Create a certificate-signing request
winpty openssl req -new -key $NAME.key -out $NAME.csr
# Create a config file for the extensions
>$NAME.ext cat <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = facebook.com # Be sure to include the domain name here because Common Name is not so commonly honoured by itself
EOF
# Create the signed certificate
winpty openssl x509 -req -in $NAME.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial \
-out $NAME.crt -days 825 -sha256 -extfile $NAME.ext

#https://stackoverflow.com/questions/7580508/getting-chrome-to-accept-self-signed-localhost-certificate/43666288#43666288
#https://stackoverflow.com/questions/10175812/how-to-create-a-self-signed-certificate-with-openssl
# generate CA key and certificate
openssl genrsa -des3 -out ca.key 4096
openssl req -new -x509 -days 365 -key ca.key -out ca.crt

# generate server key
# generate CSR (certificate sign request) to obtain certificate
openssl genrsa -des3 -out server.key 1024
openssl req -new -key server.key -out server.csr

# sign server CSR with CA certificate and key
openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

# remove pass phase from server key
openssl rsa -in server.key -out temp.key
rm server.key
mv temp.key server.key
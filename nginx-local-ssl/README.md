# Nginx with self signed SSL

## Create certs and keys
./generate-certs.sh
## Build the nginx.local image
docker build -t kubernautslabs/nginx.local .

docker push kubernautslabs/nginx.local:latest

## Related resources
https://medium.com/rahasak/set-up-ssl-certificates-on-nginx-c51f7dc00272




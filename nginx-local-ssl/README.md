# Nginx with self signed SSL

## Create certs and keys with mkcert

```
mkcert '*.nginx.local'
cp _wildcard.nginx.local.pem server.crt
cp _wildcard.nginx.local-key.pem server.key
rm _wildcard.nginx.local.pem
rm _wildcard.nginx.local-key.pem
# kubectl create secret tls tls-nginx-local --cert=./server.crt --key=./server.key
kubectl create secret generic tls-nginx-local --from-file=./server.crt --from-file=./server.key
```
## Build the nginx.local image and push

Change kubernautslabs with your own dockerhub account name:

```
docker build -t kubernautslabs/nginx.local .
docker push kubernautslabs/nginx.local:latest
```
## Related resources

https://medium.com/rahasak/set-up-ssl-certificates-on-nginx-c51f7dc00272

https://github.com/nginxinc/kubernetes-ingress




#!/bin/bash
export KUBECONFIG=kube_config_cluster.yml
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
curl -LO https://git.io/get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm init --service-account tiller
kubectl rollout status deployment tiller-deploy -n kube-system
#helm install stable/cert-manager --name cert-manager --namespace kube-system --version v0.5.2
#sleep 60
#kubectl -n kube-system rollout status deploy/cert-manager
# helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
kubectl create ns cattle-system
kubectl -n cattle-system create secret generic tls-ca --from-file=./ca/rancher/cacerts.pem
kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=./ca/rancher/cert.pem --key=./ca/rancher/key.pem
helm install --name rancher rancher-stable/rancher --namespace cattle-system --set hostname=rke1  --set ingress.tls.source=secret --set privateCA=true
# helm install --name rancher rancher-latest/rancher --namespace cattle-system --set hostname=rke1  --set ingress.tls.source=secret --set privateCA=true
# didn't work anymore with rancher slfsigned cert
# helm install --name rancher rancher-latest/rancher --namespace cattle-system --set hostname=rke1 --set tls=external

# Use own CA certs and keys with mkcert

# brew install mkcert
# mkcert — install
# mkcert '*.rancher.svc'
# on MacOS
# cp $HOME/Library/Application\ Support/mkcert/rootCA.pem cacerts.pem
# on Ubuntu Linux
# cp /home/ubuntu/.local/share/mkcert/rootCA.pem cacerts.pem
# cp _wildcard.rancher.svc.pem cert.pem
# cp _wildcard.rancher.svc-key.pem key.pem
# in /etc/hosts set
# 192.168.64.14 rke1.rancher.svc rke1
# helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
# kubectl create ns cattle-system
# kubectl -n cattle-system create secret generic tls-ca --from-file=./cacerts.pem
# kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=./cert.pem --key=./key.pem
# helm install --name rancher rancher-stable/rancher --namespace cattle-system --set hostname=rke1.rancher.svc  --set ingress.tls.source=secret --set privateCA=true
# open https://rke1.rancher.svc (you should get a vaild cert)



echo "############################################################################"
echo "This should take about 4 minutes, wait for the browser to pop up and enjoy :-)"
echo "############################################################################"
kubectl -n cattle-system rollout status deploy/rancher
open https:/rke1

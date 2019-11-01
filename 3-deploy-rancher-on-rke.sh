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
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
kubectl create ns cattle-system
kubectl -n cattle-system create secret generic tls-ca --from-file=./ca/rancher/cacerts.pem
kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=./ca/rancher/cert.pem --key=./ca/rancher/key.pem
helm install --name rancher rancher-stable/rancher --namespace cattle-system --set hostname=rke1  --set ingress.tls.source=secret --set privateCA=true
# didn't work anymore with rancher slfsigned cert
# helm install --name rancher rancher-latest/rancher --namespace cattle-system --set hostname=rke1 --set tls=external
echo "############################################################################"
echo "This should take about 4 minutes, wait for the browser to pop up and enjoy :-)"
echo "############################################################################"
kubectl -n cattle-system rollout status deploy/rancher
open https:/rke1
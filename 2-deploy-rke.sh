#!/bin/bash

RKE_Version=1.1.3
echo "downloading rke v"$RKE_Version

wget https://github.com/rancher/rke/releases/download/v$RKE_Version/rke_darwin-amd64
chmod +x rke_darwin-amd64
./rke_darwin-amd64 up --config cluster.yml

rm rke_darwin-amd64
# if something goes wrong, remore rke
# if ($1 == 0) {
# #   ./rke_darwin-amd64 remove --config cluster.yml
# }
echo "exit value "$1



# echo "############################################################################"
# export KUBECONFIG=kube_config_cluster.yml
# kubectl -n kube-system rollout status deployment/calico-kube-controllers
# # kubectl -n cattle-system rollout status daemonset.apps/cattle-node-agent
# kubectl get nodes
# echo "are the nodes ready?"
# echo "if you face problems, please open an issue on github"
# echo "make sure all pods are running before deploying Rancher Server on your RKE"
# echo "run:"
# echo "KUBECONFIG=kube_config_cluster.yml kubectl get all -A"
# echo "This may take about 5 minutes"
# echo "All fine?"
# echo "Now run ./3-deploy-rancher-on-rke.sh"
# echo "or"
# echo "Now run ./3-deploy-rancher-on-rke-mkcert-macos.sh"
# echo "############################################################################"

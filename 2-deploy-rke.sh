#!/bin/bash

# rm -fv kube_config_cluster.yml

echo "downloading rke v1.2.11"
# wget https://github.com/rancher/rke/releases/download/v0.2.8/rke_linux-amd64
# sudo chmod +x rke_linux-amd64
#./rke_linux-amd64 up --config cluster.yml
# wget https://github.com/rancher/rke/releases/download/v0.2.8/rke_darwin-amd64
# wget https://github.com/rancher/rke/releases/download/v0.3.0/rke_darwin-amd64
# wget https://github.com/rancher/rke/releases/download/v0.3.2/rke_darwin-amd64
# wget https://github.com/rancher/rke/releases/download/v1.0.8/rke_darwin-amd64
# wget https://github.com/rancher/rke/releases/download/v1.1.7/rke_darwin-amd64
# wget https://github.com/rancher/rke/releases/download/v1.1.19/rke_darwin-amd64
# wget https://github.com/rancher/rke/releases/download/v1.2.11/rke_darwin-amd64
wget https://github.com/rancher/rke/releases/download/v1.3.2/rke_darwin-amd64
chmod +x ./rke_darwin-amd64
./rke_darwin-amd64 up --config cluster.yml
# if something goes wrong, remore rke
# ./rke_darwin-amd64 remove --config cluster.yml
sleep 30
# echo "downloading kubectl"
# curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl
# curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/darwin/amd64/kubectl
# chmod +x ./kubectl

echo "############################################################################"
export KUBECONFIG=kube_config_cluster.yml
kubectl -n kube-system rollout status deployment/calico-kube-controllers
# kubectl -n cattle-system rollout status daemonset.apps/cattle-node-agent
kubectl get nodes
echo "are the nodes ready?"
echo "if you face problems, please open an issue on github"
echo "make sure all pods are running before deploying Rancher Server on your RKE"
echo "run:"
echo "KUBECONFIG=kube_config_cluster.yml kubectl get all -A"
echo "This may take about 5 minutes"
echo "All fine?"
echo "Now run ./3-deploy-rancher-on-rke.sh"
echo "or"
echo "Now run ./3-deploy-rancher-on-rke-mkcert-macos.sh"
echo "############################################################################"

# Upgrade to k8s 1.14.6
# echo "download rke v0.2.8 for k8s 1.14.6"
# wget https://github.com/rancher/rke/releases/download/v0.2.8/rke_linux-amd64
# chmod +x rke_linux-amd64
# mv rke_linux-amd64 rke028
# vi cluster.yml
# set #kubernetes: rancher/hyperkube:v1.14.6-rancher1
# cp .kube/config kube_config_cluster.yml
# ./rke028 up


# Create cluster.yaml file
# rm -fv kube_config_cluster.yml
# cat cluster.yml.template > cluster.yml
# for NODE in ${NODES}; do
#	[[ "${NODE}" =~ "rke" ]] && sed -i -e "s/${NODE}/$(lxc exec ${NODE} -- bash -c 'ip -4 addr show eth0 | grep -oP "(?<=inet ).*(?=/)"')/" cluster.yml
# done

# Deploy Kubernetes cluster with rke
# rke up

# Install rancher on rancher node
# lxc exec rancher -- docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher

# Open rancher webui
# echo     $(lxc exec rancher -- ip -4 addr show eth0 | grep -oP "(?<=inet ).*(?=/)" )
# xdg-open https://$(lxc exec rancher -- ip -4 addr show eth0 | grep -oP "(?<=inet ).*(?=/)" )

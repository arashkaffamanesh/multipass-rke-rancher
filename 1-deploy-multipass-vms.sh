#!/bin/bash
GREEN='\033[0;32m'
LB='\033[1;34m' # light blue
NC='\033[0m' # No Color

nodeCount=2
read -p  "How many worker nodes do you want?(default:2) promt with [ENTER]:" inputNode
nodeCount="${inputNode:-$nodeCount}"
cpuCount=2
read -p  "How many cpus do you want per node?(default:2) promt with [ENTER]:" inputCpu
cpuCount="${inputCpu:-$cpuCount}"
memCount=4
read -p  "How many gigabyte memory do you want per node?(default:4) promt with [ENTER]:" inputMem
memCount="${inputMem:-$memCount}"
diskCount=10
read -p  "How many gigabyte diskspace do you want per node?(default:10) promt with [ENTER]:" inputDisk
diskCount="${inputDisk:-$diskCount}"

# MASTER=$(echo "rke-master ") && 
WORKER=$(eval 'echo rke{1..'"$nodeCount"'}')

# NODES+=$MASTER
NODES+=$WORKER

# Create containers
for NODE in ${NODES}; do multipass launch --name ${NODE} --cpus ${cpuCount} --mem ${memCount}G --disk ${diskCount}G; done

# Wait a few seconds for nodes to be up
sleep 5

echo "############################################################################"
echo "multipass containers installed:"
multipass ls
echo "############################################################################"

# Create the hosts file
cp /etc/hosts hosts.backup
cp /etc/hosts hosts
./create-hosts.sh

echo "We need to write the host entries on your local machine to /etc/hosts"
echo "Please provide your sudo password:"
sudo cp hosts /etc/hosts

for NODE in ${NODES}; do
  multipass transfer hosts ${NODE}:
  multipass transfer ~/.ssh/id_rsa.pub ${NODE}:
  multipass exec ${NODE} -- sudo iptables -P FORWARD ACCEPT
  multipass exec ${NODE} -- bash -c 'sudo cat /home/ubuntu/id_rsa.pub >> .ssh/authorized_keys'
  multipass exec ${NODE} -- bash -c 'sudo chown ubuntu:ubuntu /etc/hosts'
  multipass exec ${NODE} -- bash -c 'sudo cat /home/ubuntu/hosts >> /etc/hosts'
done

# Install Docker
for NODE in ${NODES}; do
	echo -e "install docker on "${NODE}
	multipass exec ${NODE} -- bash -c 'curl https://releases.rancher.com/install-docker/19.03.sh | sh'
	multipass exec ${NODE} -- sudo usermod -aG docker ubuntu
	multipass exec ${NODE} -- sudo docker --version
done

echo "############################################################################"
echo "Make sure your /etc/hosts file on your localhost and the multipass hosts"
echo "have these host entries like:"
cat hosts | grep rke
echo ""
echo "You have to set the host entries on your localhost manually by running:"
echo "sudo cat hosts >> /etc/hosts"
echo "and run ./2-deploy-rke.sh"
echo "############################################################################"

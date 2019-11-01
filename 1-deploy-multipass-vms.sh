#!/bin/bash
# multipass delete $(echo rke{1..3})
NODES=$(echo rke{1..3})

# Create containers
for NODE in ${NODES}; do multipass launch --name ${NODE} --cpus 2 --mem 2G --disk 8G ; done
#  for NODE in ${NODES}; do multipass launch --name ${NODE} --cpus 2 --mem 2G --disk 8G --cloud-init cloud-config.yaml; done
# for NODE in ${NODES}; do multipass launch --name ${NODE} --cloud-init cloud-config.yaml; done
# for NODE in ${NODES}; do multipass launch --name ${NODE}; done

# Wait a few seconds for nodes to be up
sleep 20

echo "############################################################################"
echo "multipass containers installed:"
multipass ls
echo "############################################################################"

# Install Docker
for NODE in ${NODES}; do
    # multipass exec ${NODE} -- bash -c 'curl https://releases.rancher.com/install-docker/18.09.sh | sh'
	multipass exec ${NODE} -- bash -c 'curl https://releases.rancher.com/install-docker/19.03.sh | sh'
	multipass exec ${NODE} -- sudo usermod -aG docker ubuntu 
	multipass exec ${NODE} -- sudo docker --version
done

# Print nodes ip addresses
for NODE in ${NODES}; do
	multipass exec ${NODE} -- bash -c 'echo -n "$(hostname) " ; ip -4 addr show enp0s2 | grep -oP "(?<=inet ).*(?=/)"'
	# multipass exec ${NODE} -- bash -c 'ip -4 addr show enp0s2 | grep -oP "(?<=inet ).*(?=/)";echo -n "$(hostname) "'
done

# Create the hosts file
./create-hosts.sh > hosts

for NODE in ${NODES}; do
# multipass transfer hosts ${NODE}:/home/ubuntu/
# workaround due to this issue: https://github.com/CanonicalLtd/multipass/issues/1165#issuecomment-548762510
multipass transfer hosts ${NODE}:
multipass exec ${NODE} -- bash -c 'sudo chown ubuntu:ubuntu /etc/hosts'
multipass exec ${NODE} -- bash -c 'sudo cat /home/ubuntu/hosts >> /etc/hosts'
multipass transfer ~/.ssh/id_rsa.pub ${NODE}:
multipass exec ${NODE} -- bash -c 'sudo cat /home/ubuntu/id_rsa.pub >> .ssh/authorized_keys'
done

echo "We need to write the host entries on your local machine to /etc/hosts"
echo "Please provide your sudo password:"
cp /etc/hosts etchosts
cat hosts | sudo tee -a etchosts
# workaround to get rid of characters appear as ^M in the hosts file (OSX Catalina)
tr '\r' '\n' < etchosts > etchosts.unix
cp etchosts.unix /etc/hosts

echo "############################################################################"
echo "Make sure your /etc/hosts file on your localhost and the multipass hosts"
echo "have these host entries like:"
cat hosts
echo ""
echo "You have to set the host entries on your localhost manually by running:"
echo "sudo cat hosts >> /etc/hosts"
echo "and run ./2-deploy-rke.sh"
echo "############################################################################"

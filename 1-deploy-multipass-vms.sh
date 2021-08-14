#!/bin/bash
# multipass delete $(echo rke{1..3})
NODES=$(echo rke{1..3})

# Create containers
for NODE in ${NODES}; do multipass launch --name ${NODE} --cpus 2 --mem 4G --disk 10G --cloud-init cloud-config-systemd-resolved.yaml; done
#  for NODE in ${NODES}; do multipass launch --name ${NODE} --cpus 2 --mem 2G --disk 8G --cloud-init cloud-config.yaml; done
# for NODE in ${NODES}; do multipass launch --name ${NODE} --cloud-init cloud-config.yaml; done
# for NODE in ${NODES}; do multipass launch --name ${NODE}; done

# Wait a few seconds for nodes to be up
sleep 10

echo "############################################################################"
echo "multipass containers installed:"
multipass ls
echo "############################################################################"

# Install Docker
for NODE in ${NODES}; do
    # multipass exec ${NODE} -- bash -c 'curl https://releases.rancher.com/install-docker/18.09.sh | sh'
	# multipass exec ${NODE} -- bash -c 'curl https://releases.rancher.com/install-docker/19.03.sh | sh'
	multipass exec ${NODE} -- bash -c 'curl https://releases.rancher.com/install-docker/20.10.sh | sh'
	multipass exec ${NODE} -- sudo usermod -aG docker ubuntu 
	multipass exec ${NODE} -- sudo docker --version
	multipass exec ${NODE} -- bash -c 'sudo apt-get install -y uidmap'
	multipass exec ${NODE} -- bash -c 'dockerd-rootless-setuptool.sh install --force'
	multipass exec ${NODE} -- bash -c 'echo "export PATH=/usr/bin:$PATH" >> ~/.bashrc'
	multipass exec ${NODE} -- bash -c 'echo "export DOCKER_HOST=unix:///run/user/1000/docker.sock" >> ~/.bashrc'
    multipass exec ${NODE} -- bash -c 'systemctl --user restart docker.service'
	multipass exec ${NODE} -- bash -c 'systemctl --user status docker.service >/dev/null'
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

echo "We need to write the rke host entries on your local machine to /etc/hosts"
echo "Your /etc/hosts file will be backup'ed as /etc/hosts.backup.today and etchosts in the current directory"
echo "Please provide your sudo password:"
sudo cp /etc/hosts /etc/hosts.backup.today
sudo cp /etc/hosts etchosts
sudo cat hosts | sudo tee -a etchosts
sudo cp etchosts /etc/hosts
# # workaround to get rid of characters appear as ^M in the hosts file (OSX Catalina)
# tr '\r' '\n' < etchosts > etchosts.unix
# cp etchosts.unix /etc/hosts

echo "############################################################################"
echo "Make sure your /etc/hosts file on your localhost and the multipass hosts"
echo "have these host entries like this:"
cat hosts
# the below command works only if the /etc/hosts file is owned by your user and not the root user
# run sudo chown <your user> /etc/hosts and uncomment the line below
echo ""
echo "and run ./2-deploy-rke.sh"
echo "############################################################################"

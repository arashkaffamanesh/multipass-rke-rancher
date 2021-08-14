#!/bin/bash
# multipass delete $(echo rke{1..3})
NODES=$(echo rke{1..3})

# Create containers
for NODE in ${NODES}; do multipass launch --name ${NODE} --cpus 2 --mem 4G --disk 10G ; done

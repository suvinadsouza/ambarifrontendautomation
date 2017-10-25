#!/bin/bash
#
# This script creates and mounts partitions for all disks available in the servers listed in file "newNodes"
# ./setupFileSystem
#

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Partitioning and mounting filesystem"
for node in `cat AllNodes`; do
 scp _setupFS.sh $node:/root
 echo "Running Setup at $node"
 ssh $node "/root/_setupFS.sh &> /tmp/diskSetup.log"&
done
wait
echo "DONE > Partitioning and mounting filesystem"

# Test how many disk were consistently mounted on all nodes of the cluster
min_mted=999
for node in `cat AllNodes`; do
 mted=`ssh $node "df -h | grep disk | wc -l"`
 if [[ $mted -lt $min_mted ]]; then
  min_mted=$mted
 fi
done

echo "disk 1 to $min_mted consistently partitioned and mounted across the cluster"

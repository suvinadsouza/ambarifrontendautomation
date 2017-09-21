#!/bin/bash

echo "Unmounting currently mounted disks and removing them from /etc/fstab"
for disk in `df -h | grep -i disk | awk '{print substr($NF,2)}'`; do
 sed -i '/'$disk'/d' /etc/fstab
 umount /"$disk"
 rm -rf /"$disk"
done
echo "DONE > Unmounting currently mounted disks and removing them from /etc/fstab"


echo "Get List of Disks to partition"
#this is to make sure we don't mess with disks holding / or /boot for example
#mounted Disks
df -h | awk '{print substr($1,1,8)}' > /tmp/mDisks
#All external Disks
parted -l | grep "Disk /dev" | awk '{print substr($2,1,length($2)-1)}' > /tmp/eDisks

#Disks to be partitioned/mounted
D_List=`grep -Fxv -f /tmp/mDisks /tmp/eDisks`
echo "DONE > Get List of Disks to partition"

echo "Corrupting and removing partitions if they exist"
for D in $D_List; do
 D_Name=`echo $D | awk -F"/" '{print $NF}'`
 D_Parts=`cat /proc/partitions | grep $D_Name | grep -v $D_Name\$ | wc -l`
 if [[ $D_Parts -eq 0 ]]; then
  continue
 else
  for (( part=1 ; part<=$D_Parts; part++)); do
   dd if=/dev/zero of=$D$part bs=5M count=1
   parted -s $D rm $part
  done
 fi
done
echo "DONE > Corrupting and removing partitions if they exist"

D_num=1
for D in $D_List; do
 D_size=`parted -l | grep $D | awk '{print $NF}'`
 echo "Create partition for disk $D"
 if (parted -s $D mktable gpt); then
  echo "mkpart"
  parted -s $D mkpart primary 0000GB $D_size
  echo "mkfs"
  mkfs.ext4 -F "$D"1
 else
  continue
 fi
 echo "Mount partition"
 mkdir /disk_"$D_num"
 mount "$D"1 /disk_"$D_num"
 echo "$D"1  /disk_"$D_num"  ext4 defaults        0 0 >> /etc/fstab
 echo "DONE > Setting up disk $D"
 ((D_num++))
done

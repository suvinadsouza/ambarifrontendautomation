#!/bin/sh

# This script will replicated all users that exist on the bdvm004.svl.ibm.com LDAP server to the local OS.  Make sure the following users/groups are not on the system before running.
# Run with the biadmin or root user.
# Created by Raj Desai (rddesai@us.ibm.com).

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

usage(){
        echo "Usage: $0 <comma separated node list>"
        exit 1
}

# invoke  usage
# call usage() function if filename not supplied
[[ $# -eq 0 ]] && usage

IFS=','
NODE_LIST=$1
USER_LIST="biadmin:biadmin,mapred:hadoop,hbase:hadoop,ambari-qa:hadoop,zookeeper:hadoop,hdfs:hadoop,yarn:hadoop,hive:hadoop,flume:hadoop,hcat:hadoop,oozie:hadoop,knox:hadoop,tez:hadoop,sqoop:hadoop,spark:hadoop,bigsql:hadoop,bigsheets:hadoop,bigr:hadoop,nobody:hadoop,sqluser:hadoop,hadoop:hadoop,solr:hadoop,kafka:hadoop,ams:hadoop,tauser:hadoop,uiuser:hadoop,nagios:nagios,postgres:postgres,mysql:mysql,apache:apache,falcon:falcon,rrdcached:rrdcached,user1:users,user2:users,user3:users,titan:hadoop,infra-solr:hadoop,logsearch:hadoop"
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for _Node in $NODE_LIST; do

echo "Deleting biadmin if user exists on $_Node"
# If equal to zero then delete the user.
ssh $_Node sudo id biadmin
if [ "$?" -eq "0" ];then
    ssh $_Node sudo userdel -f biadmin
    ssh $_Node sudo groupdel biadmin
fi

echo "Installing required packages on $_Node..."
ssh $_Node sudo yum -y install openldap
ssh $_Node sudo yum -y install openldap-clients
ssh $_Node sudo yum -y install nss-pam-ldapd
ssh $_Node sudo yum -y install nss_ldap
ssh $_Node sudo yum -y install authconfig

echo "Enabling $_Node local OS authentication for users on bdvm004.svl.ibm.com LDAP server."
ssh $_Node sudo authconfig --enableldap --enableldapauth --enablemkhomedir --enablesysnetauth --enableforcelegacy --ldapserver=ldap://bdvm004.svl.ibm.com:2389 --ldapbasedn="dc=ibm,dc=com" --update

# The following sleep is for systems that take a little longer for the system to catch up with the LDAP users.  I have only noticed this on the hdpxxx.svl.ibm.com systems.
sleep 5

echo "Creating home directories for users on $_Node"

for _UserGroup in $USER_LIST; do

_User=$(echo "$_UserGroup" | cut -d: -f1)

ssh $_Node sudo "[ -d /home/$_User ]"
if [ "$?" -eq "1" ];then
    ssh $_Node sudo mkdir /home/$_User
    sudo scp $DIR/.bashrc $_Node:/home/$_User/.bashrc > /dev/null 2>&1
    sudo scp $DIR/.bash_profile $_Node:/home/$_User/.bash_profile > /dev/null 2>&1
fi
ssh $_Node sudo chown -R $_UserGroup /home/$_User

done

echo "Check to insure the following users/groups/uids/gids are correct on $_Node"
for _UserGroup in $USER_LIST; do

_User=$(echo "$_UserGroup" | cut -d: -f1)
ssh $_Node sudo id $_User

done

done

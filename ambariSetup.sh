#ambari-server pre-req installs
: '
echo -e "Enter space separated List of host IP addresses in your cluster(172.16.152.68 172.16.152.69)\n"
read ipaddress
echo -e "Enter space separated List of host FQDNs in your cluster(chum1.fyre.ibm.com chum2.fyre.ibm.com)\n"
read hostlist
echo -e "Enter space separated List of host shortnames in your cluster(chum1 chum2)\n"
read shortnames
echo -e "Enter the number of nodes in your cluster\n"
read number_of_nodes
echo -e "Enter the path to the ambari/hdp repo you want to use\n"
read ambari_repo_path
echo -e "Enter the non root user name you want to use, if at all\n"
read nonroot_user
echo -e "Enter the non root user password you want to use, if at all\n"
read nonroot_user_passwd
echo -e "Enter the FQDN of the ambari node\n"
read ambariserver
echo -e "Enter the root user password you want to use, if at all\n"
read root_user_passwd
echo -e "Enter the FQDN of the KDC(Kerberos) server you want to use, if at all for local kdc setup\n"
read KDCServer
echo -e "Enter the bigsql head node FQDN\n"
read bigsqlHead
echo -e "Enter whether you system is power or intel(p or x)\n"
read ostype
echo -e "Enter the ldap server FQDN\n"
read ldapServer
echo -e "Enter the ldap server port(e.g. 2389)\n"
read ldapserver_port

echo -e " creating hostdetails file, waiting for 15secs\n"
cat /dev/null > /tmp/installautomation/hostdetails &
echo -e "$ipaddress\n" >> /tmp/installautomation/hostdetails &
sleep 2s
echo -e "$hostlist\n" >> /tmp/installautomation/hostdetails &
sleep 2s
echo -e "$shortnames\n" >> /tmp/installautomation/hostdetails &
sleep 2s
echo -e "$number_of_nodes\n" >> /tmp/installautomation/hostdetails &
sleep 2s
echo -e "$ambari_repo_path\n" >> /tmp/installautomation/hostdetails &
sleep 2s
echo -e "$nonroot_user\n" >> /tmp/installautomation/hostdetails &
sleep 2s
echo -e "$ambariserver\n" >> /tmp/installautomation/hostdetails &
sleep 2s
echo -e "$nonroot_user_passwd\n" >> /tmp/installautomation/hostdetails &
sleep 2s
echo -e "$root_user_passwd\n" >> /tmp/installautomation/hostdetails &
sleep 2s
echo -e "$KDCServer\n" >> /tmp/installautomation/hostdetails &
sleep 2s
echo -e "$bigsqlHead\n" >> /tmp/installautomation/hostdetails &
sleep 2s
echo -e "$ostype\n" >> /tmp/installautomation/hostdetails &
sleep 2s
echo -e "$ldapServer\n" >> /tmp/installautomation/hostdetails &
sleep 2s
echo -e "$ldapserver_port\n" >> /tmp/installautomation/hostdetails &
sleep 2s
wait
'

#Decide between root or non root setup for ambari
#echo -e "\nDo you want to do Root Ambari/hdp Setup or Non Root Ambari/hdp Setup(Root/NonRoot)?\n"
#read ambariSetupType

path_to_hostdetails=$1
ambariSetupType=$2


# remove comments and blank lines from hostdetails file
/tmp/installautomation/createhostdetailsNew.sh $path_to_hostdetails | tee /tmp/installautomation/hostdetails_new.txt

if [ "$ambariSetupType" == "Root" ]
then
echo -e "started Root setup \n"
sed -i -e 's/\r$//' /tmp/installautomation/rootAmbariSetup.sh
chmod 777 /tmp/installautomation/rootAmbariSetup.sh
chmod 777 /tmp/installautomation/hostdetails_new.txt
/tmp/installautomation/rootAmbariSetup.sh /tmp/installautomation/hostdetails_new.txt
else
echo -e "Started Non Root Setup\n"
sed -i -e 's/\r$//' /tmp/installautomation/nonRootAmbariSetup.sh
chmod 777 /tmp/installautomation/nonRootAmbariSetup.sh
chmod 777 /tmp/installautomation/hostdetails_new.txt
/tmp/installautomation/nonRootAmbariSetup.sh /tmp/installautomation/hostdetails_new.txt
fi

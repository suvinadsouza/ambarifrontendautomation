#!/bin/bash
#full ambari setup script; the script combines cleanup, prereq setup, ldap setup, ssl setup and root and non root setup based on user preferences
#script will work assuming the user has followed instructions in readme file

#full ambari setup script; the script combines cleanup, prereq setup, ldap setup, ssl setup and root and non root setup based on user preferences
#script will work assuming the user has followed instructions in readme file

path_to_hostdetails=$1

IFS=$'\r\n' GLOBIGNORE='*' command eval  'lines=($(cat $path_to_hostdetails))'
echo -e "non root user: ${lines[5]}\n"
sleep 1s
nonrootusername=${lines[5]}
echo -e "non root user name: ${lines[5]}\n"
nonrootpasswd=${lines[7]}
echo -e "non root password: ${lines[7]}\n"
rootpasswd=${lines[8]}
echo -e "root user passwd: ${lines[8]}\n"
echo -e "ambari server: ${lines[6]}\n"
sleep 1s
ambariServer=${lines[6]}
echo -e "KDC Server: ${lines[9]}\n"
KDCServer=${lines[9]}
sleep 1s
echo -e "BigSQL Head: ${lines[10]}\n"
bigsqlHead=${lines[10]}
sleep 1s
echo -e "os type : ${lines[11]}\n"
ostype=${lines[11]}
sleep 1s
echo -e "ldap server type : ${lines[12]}\n"
ldapServer=${lines[12]}
sleep 1s
echo -e "ldap server port : ${lines[13]}\n"
ldapserver_port=${lines[13]}
sleep 1s
echo -e "pre-req : ${lines[14]}\n"
prerequisites=${lines[14]}
sleep 1s
echo -e "nonrootusercreation : ${lines[15]}\n"
nonrootusercreation=${lines[15]}
sleep 1s
echo -e "LDAPuserResponse : ${lines[16]}\n"
LDAPuserResponse=${lines[16]}
sleep 1s
echo -e "twoWaySSLResponse : ${lines[17]}\n"
twoWaySSLResponse=${lines[17]}
sleep 1s
echo -e "SSLuserResponse : ${lines[18]}\n"
SSLuserResponse=${lines[18]}
sleep 1s
echo -e "KDCuserResponse : ${lines[19]}\n"
KDCuserResponse=${lines[19]}
sleep 1s
echo -e "remove_root_ssh : ${lines[20]}\n"
remove_root_ssh=${lines[20]}
sleep 1s
echo -e "cleanup : ${lines[21]}\n"
cleanup=${lines[21]}
sleep 1s
echo -e "ambari-agent : ${lines[22]}\n"
ambari_agent=${lines[22]}
sleep 1s
echo -e "ambari-server : ${lines[23]}\n"
ambari_server=${lines[23]}
sleep 1s
echo -e "path to repo files : ${lines[24]}\n"
pathToRepoFiles=${lines[24]}
sleep 1s
echo -e "path to extension files : ${lines[25]}\n"
pathToExtScripts=${lines[25]}
sleep 1s


#echo -e "\nEnter the non root username\n"
#read nonrootusername
#echo -e "\nEnter the ambari server head node FQDN\n"
#read ambariServer
#echo -e "\nEnter the bigsql head node FQDN\n"
#read bigsqlHead

IFS=', ' read -r -a hostnamesArray <<< "${lines[1]}"

echo -e "\n the host list is \n"
#list hostnames:#test1
for i in "${hostnamesArray[@]}"
do
echo -e "$i \n"
done
#read -p  "enter an array of fully qualified hostnames separated by space " -a hostnamesArray

: '
#installing sshpass for power 7.x
if [ "$ostype" == "p" ]
then
for i in "${hostnamesArray[@]}"
do
echo -e "you are in host $i \n"
ssh root@$i "wget ftp://rpmfind.net/linux/fedora-secondary/releases/26/Everything/ppc64le/os/Packages/s/sshpass-1.06-2.fc26.ppc64le.rpm"
ssh root@$i "rpm -ivh sshpass-1.06-2.fc26.ppc64le.rpm"
sleep 10s
done
fi
'

#installing jdk for power 7.x
if [ "$ostype" == "p" ]
then
for i in "${hostnamesArray[@]}"
do
echo -e "you are in host $i \n"
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$i "wget -P /usr/jdk64 http://birepo-build.svl.ibm.com/repos/IOP-UTILS/RHEL7/ppc64le/1.3/openjdk/jdk-1.8.0.tar.gz"
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$i "tar -zxvf /usr/jdk64/jdk-1.8.0.tar.gz -C /usr/jdk64"
sleep 2s
done
fi

: '
#installing sshpass for x86 intel 6.x or 7.x
if [ "$ostype" == "x" ]
then
for i in "${hostnamesArray[@]}"
do
echo -e "you are in host $i \n"
if ssh root@$i "sudo cat /etc/redhat-release | grep 6" ; then
ssh root@$i "wget ftp://195.220.108.108/linux/dag/redhat/el6/en/x86_64/dag/RPMS/sshpass-1.05-1.el6.rf.x86_64.rpm"
ssh root@$i "rpm -ivh sshpass-1.05-1.el6.rf.x86_64.rpm"
sleep 10s
elif ssh root@$i "sudo cat /etc/redhat-release | grep 7" ; then
ssh root@$i "wget ftp://195.220.108.108/linux/fedora/linux/releases/26/Everything/x86_64/os/Packages/s/sshpass-1.06-2.fc26.x86_64.rpm"
ssh root@$i "rpm -ivh sshpass-1.06-2.fc26.x86_64.rpm"
fi
done
fi
'

for i in "${hostnamesArray[@]}"
do
echo -e "\nthe current hostname is:$i\n"
sleep 1s
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$i 'yum repolist all'
done

#create node list file on every node:#test2
echo -e "\ncreating nodeList file on every node, process will take some time...\n"
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$ambariServer 'rm -rf /tmp/installautomation/nodeList' 2> /dev/null
sleep 1s
echo -e "started nodeList setup on $ambariServer\n"
for i in "${hostnamesArray[@]}"
do
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$ambariServer "echo $i >> /tmp/installautomation/nodeList" 2> /dev/null
sleep 1s
done
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$ambariServer 'chmod 777 /tmp/installautomation/nodeList' 2> /dev/null
sleep 1s
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$ambariServer 'dos2unix /tmp/installautomation/nodeList' 2> /dev/null
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$ambariServer 'cat /tmp/installautomation/nodeList'
sleep 1s
echo -e "created nodeList for $ambariServer\n"

#copying node list to other nodes:#test3
for i in "${hostnamesArray[@]}"
do
echo -e "copying nodeList to $i\n"
sshpass -p $rootpasswd scp -r /tmp/installautomation root@$i:/tmp
sleep 1s
done 

#reset root passwordless ssh if it was removed for non root setup:test4
#assuming that you have an existing nodeList file
sed -i -e 's/\r$//' /tmp/installautomation/*.sh
cat /tmp/installautomation/nodeList
sshpass -p $rootpasswd ssh $ambariServer -t -l root " chmod 777 /tmp/installautomation/setupSSH.sh"
sshpass -p $rootpasswd ssh $ambariServer -t -l root "/tmp/installautomation/setupSSH.sh $rootpasswd root"
echo -e "waiting for 3secs\n"
sleep 3s

#copy scripts to other nodes : #test5
echo -e "copying scripts to other nodes, process will take some time...\n"
for i in "${hostnamesArray[@]}"
do
#enable repos
#sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$i "yum repolist all" 2> /dev/null &
wait
#install dos2unix converter if not already installed on all cluster nodes
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$i "yum install dos2unix -y" 2> /dev/null &
wait
#issue in this statement
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$i "chmod 777 /tmp/installautomation" 2> /dev/null &
wait
#copy the scripts to all nodes in the cluster
sshpass -p $rootpasswd scp /tmp/installautomation/*.sh root@$i:/tmp/installautomation/ 2> /dev/null &
wait
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$i "sed -i -e 's/\r$//' /tmp/installautomation/*.sh" 2> /dev/null &
wait
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$i 'chmod 777 /tmp/installautomation/*.sh' 2> /dev/null &
wait
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$i 'chmod 777 /var/log/' 2> /dev/null &
wait
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$i 'chmod 777 /var/run/' 2> /dev/null &
wait
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$i 'dos2unix /tmp/installautomation/*.sh' 2> /dev/null &
wait
scp $path_to_hostdetails root@$i:/tmp/installautomation/
sleep 1s
echo -e "copied scripts for host:$i\n"
sleep 1s
done

#cleanup existing install of ambari and valueadds: test6
#cleanup existing install of ambari and valueadds
: '
echo -e "\nDo you want to clean up existing ambari-server and value adds for non root user(yes/no)?\n"
read cleanup
'

if [ "$cleanup" == "yes" ]
then
for i in "${hostnamesArray[@]}"
do
#cleanup existing install of bigsql
echo -e "\n waiting... \n"
sshpass -p $nonrootpasswd ssh -o StrictHostKeyChecking=no $nonrootusername@$i /tmp/installautomation/bigsqlcleanup_non_root_user.sh $pathToRepoFiles $pathToExtScripts &
wait
#cleanup existing install of ambari server
echo -e "\n waiting... \n"
sshpass -p $nonrootpasswd ssh -o StrictHostKeyChecking=no $nonrootusername@$i /tmp/installautomation/ambari_nonroot_cleanup.sh $pathToRepoFiles &
wait
done
fi


: '
echo -e "\nDo you want to configure prerequisites for ambari/hdp setup(yes/no)?\n"
read prerequisites
'
#set pre-requisites : test7
if [ "$prerequisites" == "yes" ]
then
echo -e "\nstarted prereq setup \n"
sleep 1s
for i in "${hostnamesArray[@]}"
do
echo -e "you are in host $i \n"
: '
echo -e "\n Do you want to proceed?(yes/no) \n"
read user_response
if [ "$user_response" == "yes" ]
then
'
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$i /tmp/installautomation/ambari_prereq.sh $path_to_hostdetails $i
echo -e "\n waiting for 5sec \n"
sleep 3s
echo -e "completed prereq setup on $i\n"
sleep 2s
#fi
done
fi

: '
echo -e "\nDo you want to create non root user(yes/no)?\n"
read nonrootusercreation
'
#create non root user : test 8
if [ "$nonrootusercreation" == "yes" ]
then
echo -e "started non root user setup \n"
for i in "${hostnamesArray[@]}"
do
#non root user creation
echo -e "you are in host: $i\n"
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$i /tmp/installautomation/non_root_user_creation.sh $path_to_hostdetails
echo -e "\n waiting 2secs \n"
sleep 2s
done
fi

: '
echo -e "\nDo you want to configure ldap for non root user(yes/no)?\n"
read LDAPuserResponse
'
#set up ldap: test9
if [ "$LDAPuserResponse" == "yes" ]
then
#run the replicate ldap script on all nodes
for i in "${hostnamesArray[@]}"
do
sshpass -p $nonrootpasswd ssh $i -t -l $nonrootusername "telnet $ldapServer"
sshpass -p $nonrootpasswd ssh $i -t -l $nonrootusername "sudo systemctl restart systemd-logind" #sudo issue with rhel 6.8
sshpass -p $nonrootpasswd ssh $i -t -l $nonrootusername "sudo systemctl restart sshd" #sudo issue with rhel 6.8
sshpass -p $nonrootpasswd ssh $i -t -l $nonrootusername "sudo service systemd-logind restart" #sudo issue with rhel 6.8
sshpass -p $nonrootpasswd ssh $i -t -l $nonrootusername "sudo service sshd restart" #sudo issue with rhel 6.8
sleep 1s
echo -e "you are executing for node $i\n"
if [ "$ldapServer" == "bdvm003.svl.ibm.com" ]
then
echo -e "\nldap server is bdvm003.svl.ibm.com\n"
/tmp/installautomation/replicateIOPLDAP-bdvm003.sh $i 2> /dev/null &
wait
else
echo -e "\nldap server is bdvm004.svl.ibm.com\n"
/tmp/installautomation/replicateIOPLDAP-bdvm004.sh $i 2> /dev/null &
wait
fi
echo -e "completed ldap users creation on node $i\n"
#add mahout user on all nodes for HDP cluster
sshpass -p $rootpasswd ssh -o StrictHostKeyChecking=no root@$i "useradd -g hadoop -u 1900 mahout"
done
fi

#passwordless ssh must be setup from ambari head to all nodes including itself and from bigsql head to all workers: test 10
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "/tmp/installautomation/setupSSH.sh $nonrootpasswd $nonrootusername"
echo -e "\n waiting 2secs \n"
sleep 2s
if [ "$ambariServer" == "$bigsqlHead" ]
then
echo -e "\n Passwordless ssh is already set up from ambari server to all cluster nodes \n"
else
echo -e "\n Setting up passwordless ssh from bigsql head to other nodes in the cluster \n"
sshpass -p $nonrootpasswd ssh $bigsqlHead  -t -l $nonrootusername "/tmp/installautomation/setupSSH.sh $nonrootpasswd $nonrootusername"
echo -e "\n waiting 2secs \n"
sleep 2s
fi

: '
echo -e "\nDo you want to install ambari-agent for non root user(yes/no)?\n"
read ambari-agent
'
#set up ambari agent: test11
if [ "$ambari_agent" == "yes" ]
then
#ambari agents need to be set up on all nodes in the cluster
for i in "${hostnamesArray[@]}"
do
echo -e "you are installing ambari agent on node $i\n"
sshpass -p $nonrootpasswd ssh -o StrictHostKeyChecking=no $nonrootusername@$i /tmp/installautomation/nonroot_ambari_agent_setup.sh $path_to_hostdetails
echo -e "\n waiting 3secs \n"
sleep 3s
#sshpass -p $nonrootpasswd ssh $i -t -l $nonrootusername "sudo chmod -R ugo+rw /var/lib/ambari-agent/cache/stacks/BigInsights/*/services/"
sshpass -p $nonrootpasswd ssh $i -t -l $nonrootusername "sudo chmod -R ugo+rw /var/lib/ambari-agent/cache/stacks/HDP/*/services"
done
fi

: '
echo -e "\nDo you want to install ambari-server for non root user(yes/no)?\n"
read ambari-server
'
#setup ambari server: test12
if [ "$ambari_server" == "yes" ]
then
sshpass -p $nonrootpasswd ssh -o StrictHostKeyChecking=no $nonrootusername@$ambariServer sudo yum install ambari-server -y
sleep 3s
sshpass -p $nonrootpasswd ssh -o StrictHostKeyChecking=no $nonrootusername@$ambariServer sudo updatedb &
wait
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "sudo /etc/rc.d/init.d/ambari-server setup"
echo -e "\n waiting 15secs \n"
sleep 3s
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "sudo /etc/rc.d/init.d/ambari-server start"
#sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "sudo chmod -R ugo+rw /var/lib/ambari-server/resources/stacks/BigInsights/*/services/"
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "sudo chmod -R ugo+rw /var/lib/ambari-server/resources/stacks/HDP/*/services"
fi

: '
echo -e "Do you want to configure two way SSL between ambari server and ambari agents(yes/no)?\n"
read twoWaySSLResponse
'
#setup two way ssl between agents and server: test13
if [ "$twoWaySSLResponse" == "yes" ]
then
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "chmod 777 /etc/ambari-server/conf/ambari.properties"
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername 'sudo echo "security.server.two_way_ssl=true" >> /etc/ambari-server/conf/ambari.properties'
sleep 1s
cat /etc/ambari-server/conf/ambari.properties | grep security
sleep 1s
fi

#setup ldap: test14
if [ "$LDAPuserResponse" == "yes" ]
then
echo -e "\n waiting 70secs \n"
sshpass -p $nonrootpasswd ssh $ambariServer -t -l $nonrootusername "telnet $ldapServer"
sleep 2s
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "sudo /usr/sbin/authconfig --enableldap --enableldapauth --ldapserver=ldap://$ldapServer:$ldapserver_port --ldapbasedn='dc=ibm,dc=com' --update"
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "sudo /etc/rc.d/init.d/ambari-server setup-ldap"
sleep 2s
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "sudo /etc/rc.d/init.d/ambari-server restart"
sleep 2s
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "sudo /etc/rc.d/init.d/ambari-server sync-ldap --all"
sleep 2s
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "sudo /etc/rc.d/init.d/ambari-server restart"
sleep 2s
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "sudo /etc/rc.d/init.d/ambari-server sync-ldap --all" #sudo issue with rhel 6.8
sleep 2s
fi

: '
echo -e "\nDo you want to configure ssl for non root user(yes/no)?\n"
read SSLuserResponse
'
#setup ssl: test14
if [ "$SSLuserResponse" == "yes" ]
then
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "/tmp/installautomation/nonrootsslsetup.sh $ambariServer"
echo -e "\n waiting 15secs \n"
sleep 3s
else
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "sudo chmod 777 /etc/ambari-server/conf/ambari.properties"
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername 'sudo echo "client.api.port=8081" >> /etc/ambari-server/conf/ambari.properties'
sshpass -p $nonrootpasswd ssh $ambariServer  -t -l $nonrootusername "sudo /etc/rc.d/init.d/ambari-server restart"
fi

: '
echo -e "\nDo you want to configure local kdc server for non root user(yes/no)?\n"
read KDCuserResponse
'
#setup kerberos server: test15
if [ "$KDCuserResponse" == "yes" ]
then
#echo -e "Enter FQDN of KDC server\n"
#read KDCServer
#echo -e "You entered $KDCServer\n"
sshpass -p $nonrootpasswd ssh $KDCServer  -t -l $nonrootusername "/tmp/installautomation/nonrootlocalKDCSetup.sh $path_to_hostdetails"
echo -e "\n waiting 20secs \n"
sleep 2s
#sshpass -p $nonrootpasswd ssh $KDCServer  -t -l $nonrootusername "kinit admin/admin@IBM.COM"
fi

: '
echo -e "\nDo you want to remove root passwordless ssh(yes/no)?\n"
read remove_root_ssh
'
#remove root passwordless ssh : test 16
if [ "$remove_root_ssh" == "yes" ]
then
for i in "${hostnamesArray[@]}"
do
sshpass -p $nonrootpasswd ssh -o StrictHostKeyChecking=no $nonrootusername@$i 'sudo rm -rf /root/.ssh/authorized_keys*'
	echo -e "\n waiting 2secs \n"
	sleep 1s
done
fi

echo -e "\n set up complete, proceed to ambari ui\n"


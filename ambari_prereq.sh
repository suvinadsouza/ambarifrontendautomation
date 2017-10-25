#ambari-server pre-req installs
#echo -e "Enter the fully qualified domain name of current host(chum1.fyre.ibm.com)\n"
#read hostname
#echo -e "You entered: $hostname\n"
#echo -e "Enter space separated List of host FQDNs in your cluster(chum1.fyre.ibm.com chum2.fyre.ibm.com)\n"
#read hostlist
#echo -e "Enter space separated List of host IP addresses in your cluster(172.16.152.68 172.16.152.69)\n"
#read ipaddress
#echo -e "Enter space separated List of host shortnames in your cluster(chum1 chum2)\n"
#read shortnames
#echo -e "Enter the number of nodes in your cluster\n"
#read number_of_nodes

path_to_hostdetails=$1
host_name=$2

IFS=$'\r\n' GLOBIGNORE='*' command eval  'lines=($(cat $path_to_hostdetails))'
echo -e "your hostdetails file contains\n"
echo -e "host ips: ${lines[0]}\n"
echo -e "host list: ${lines[1]}\n"
echo -e "short names: ${lines[2]}\n"
echo -e "no of nodes: ${lines[3]}\n"
echo -e "ambari repo path: ${lines[4]}\n"
echo -e "non root user: ${lines[5]}\n"
echo -e "ambari server: ${lines[6]}\n"
echo -e "os type : ${lines[11]}\n"
sleep 2s

a0=(${lines[0]})
a1=(${lines[1]})
a2=(${lines[2]})
number_of_nodes=${lines[3]}
ostype=${lines[11]}


: '
echo -e "\nEnter the fully qualified domain name of current host(chum1.fyre.ibm.com)\n"
read host_name
echo -e "\nYou entered: $host_name\n"
sleep 2s
'

: '
echo -e "\n Registering your system to receive red hat subscriptions? (Enter yes/no)\n"
echo -e "\n You will need the ftp3 account username and passwd to proceed\n"
read redhat_subscription
if [ "$redhat_subscription" == "yes" ]
then
/tmp/installautomation/RHN_registration.sh
sleep 2m
fi
'

yum repolist all

#change hostname to your node
hostname $host_name
sleep 1s
hostname --long

#check DNS
echo -e "\n writing into /etc/hosts\n"
cat /dev/null > /etc/hosts &
echo -e "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4\n" >> /etc/hosts &
echo -e "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6\n" >> /etc/hosts &
echo -e "9.37.253.136    rhn.linux.ibm.com\n" >> /etc/hosts &
wait

for (( i=0; i<$number_of_nodes; i++ ))
do  
   echo -e "${a0[$i]} \t ${a1[$i]} \t ${a2[$i]} \t \n" >> /etc/hosts
   sleep 1s
done

yum makecache fast

#install ssh
yum -y install openssh-server openssh-clients
chkconfig sshd on
service sshd start

#install httpd
yum -y install httpd

#modify tty in /etc/sudoers
sed -i -e 's/Defaults    requiretty/#Defaults    requiretty/g' /etc/sudoers &
cat /etc/sudoers | grep requiretty
wait

#modify /etc/systemd/logind.conf
sed -i -e 's/#RemoveIPC=no/RemoveIPC=no/g' /etc/systemd/logind.conf &
wait
sed -i -e 's/#RemoveIPC=yes/RemoveIPC=no/g' /etc/systemd/logind.conf &
wait
cat /etc/systemd/logind.conf | grep RemoveIPC
systemctl restart systemd-logind
service systemd-logind restart
/sbin/chkconfig systemd-logind on

#install yum config manager
yum -y install yum-utils &
wait

#install nslookup packages
#yum -y install bind-utils &
#wait

#required for ldap and active directory
#install pam
yum -y install pam* &
wait


#install ntp
yum -y install ntp &
wait
chkconfig ntpd &
wait
systemctl start ntpd &
service ntpd start &
/sbin/chkconfig ntpd on
wait
systemctl enable ntpd &
service ntpd enable &
wait
systemctl status ntpd &
service ntpd status &
wait

#run the following commands to verify NTP peers synchronization status
ntpq -p &
date -R &
wait

#install telnet
yum -y install telnet &
wait

#install dos2unix package
yum -y install dos2unix &
wait

#install locate package
yum -y install mlocate &
updatedb
sudo updatedb
wait

#install traceroute
yum -y install traceroute &
wait

#install lsof
yum -y install lsof &
wait

#install yum utils
yum install yum-utils -y &
wait

#install net tools
yum install net-tools -y &
wait


#install libtirpc
yum remove libtirpc -y
yum install -y libtirpc-0.2.4-0.6.*


#install packages for BigSQL HA
yum install compat-libstdc++-* -y &
wait
yum install -y libstdc++* --setopt=protected_multilib=false &
wait
yum install -y pam* &
wait
yum install -y nss-pam-ldapd* &
wait
yum-config-manager --enable rhel-7-server-optional-rpms &
wait
yum install compat-libstdc++-* -y &
wait
yum install perl-Sys-Syslog -y &
wait
/usr/ibmpacks/bigsql/*/db2/tsampImage/prereqSAM
modprobe -r iTCO_wdt 
modprobe -r iTCO_vendor_support


echo -e "\n your /etc/hosts file contains \n"
cat /etc/hosts

#change the contents of /etc/sysconfig/network file
echo -e "NETWORKING=yes NETWORKING_IPV6=yes HOSTNAME=$host_name" >> /etc/sysconfig/network
sleep 1s

#configure IP tables
chkconfig iptables off /etc/init.d/iptables stop &
chkconfig iptables off /usr/sbin/iptables stop &
wait
systemctl stop iptables &
service iptables stop &
/sbin/chkconfig iptables off
setenforce 0 &
wait
echo "SELINUX=disabled" >> /etc/selinux/config
sleep 1s

#set umask
echo "umask 022" >> /etc/profile
sleep 1s

#disable transparent huge pages
echo never > /sys/kernel/mm/transparent_hugepage/enabled &
wait

#install ksh
yum -y install ksh &
wait

#set correct permissions on /tmp
chmod -R 777 /tmp &
chmod 777 /var/run &
chmod 777 /var/ibm &
chmod 777 /var/log &
chmod ugo+rwx /etc &
chmod go-w /etc &
chmod 777 /etc/security &
chmod ugo+rw /etc/security/keytabs &
chmod 1777 /dev/shm
rm -rf /dev/shm/*
wait

: '
#truncate files and create space
sudo truncate -s 0 /var/log/*.log* &
sudo truncate -s 0 /var/log/*/*.log* &
sudo truncate -s 0 /var/log/*/*/*.log* &
sudo truncate -s 0 /var/log/*.out* &
sudo truncate -s 0 /var/log/*/*.out* &
sudo truncate -s 0 /var/log/*/*/*.out* &
sudo truncate -s 0 /tmp/*/*.log* &
sudo truncate -s 0 /tmp/*/*.report* &
sudo truncate -s 0 /tmp/*/*.out* &
sudo truncate -s 0 /tmp/*/*/*.log* &
sudo truncate -s 0 /tmp/*/*/*.report* &
sudo truncate -s 0 /tmp/*/*/*.out* &
sudo truncate -s 0 /var/log/lastlog* &
sudo truncate -s 0 /var/log/messages* &
sudo truncate -s 0 /var/log/secure* &
sudo truncate -s 0 /var/log/cron* &
sudo truncate -s 0 /var/log/up2date* &
sudo truncate -s 0 /var/log/spooler* &
sudo truncate -s 0 /var/log/*/*/*.audit &
sudo truncate -s 0 /var/log/*/*.audit &
sudo truncate -s 0 /var/log/*.audit &
wait
'


#modify /etc/ssh/ssh_config
sed -i -e 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
cat /etc/ssh/sshd_config | grep UseDNS
sed -i -e 's/#GSSAPIAuthentication no/GSSAPIAuthentication no/g' /etc/ssh/ssh_config
sed -i -e 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/ssh_config
cat /etc/ssh/ssh_config | grep GSSAPIAuthentication
service sshd restart &
systemctl restart systemd-logind &
service systemd-logind restart &
/sbin/chkconfig systemd-logind on
wait

#display content of files
echo -e "\ncontent of /etc/hosts\n" 
cat /etc/hosts
sleep 1s
echo -e "\ncontent of /etc/sysconfig/network\n"
cat /etc/sysconfig/network
sleep 1s
echo -e "\ncontent of /etc/selinux/config\n"
cat /etc/selinux/config
sleep 1s
echo -e "\ncontent of /etc/profile\n"
tail -10 /etc/profile
sleep 1s
cat /etc/sudoers | grep requiretty
sleep 1s
cat /etc/systemd/logind.conf | grep RemoveIPC
sleep 1s
cat /etc/ssh/ssh_config | grep GSSAPIAuthentication
sleep 1s

#clean repos
yum-config-manager --enable /tmp/installautomation/*.repo &
sleep 1s
wait
#yum repolist all &
#sleep 5s
#wait
yum clean all &
sleep 1s
wait
yum clean expire-cache &
sleep 1s
wait
yum clean metadata &
sleep 1s
wait
yum clean dbcache &
sleep 1s
wait
rm -Rf /var/cache/yum &
sleep 1s
wait
rpm --rebuilddb &
sleep 1s
wait
updatedb &
sleep 1s
#yum update &
wait


#telnet to ldap server
telnet bdvm004.svl.ibm.com -l sdsouza@us.ibm.com
sleep 2s
#ping bdvm003.svl.ibm.com

#echo -e "set up passwordless ssh from ambari node to itself and from ambari node to all other nodes\n"
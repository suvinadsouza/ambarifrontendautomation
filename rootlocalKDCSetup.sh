#install on all cluster nodes, does not work on rhel 6.8, check the file modification scripts
path_to_hostdetails=$1

IFS=$'\r\n' GLOBIGNORE='*' command eval  'lines=($(cat $path_to_hostdetails))'
echo -e "non root user: ${lines[5]}\n"
sleep 1s
KDCServer=${lines[9]}
echo -e "KDC Server: ${lines[9]}\n"
sleep 1s
num_of_hosts=${lines[3]}
echo -e "number of hosts: ${lines[3]}\n"
sleep 1s
rootpassword=${lines[8]}
echo -e "root password: ${lines[8]}\n"
sleep 1s

sudo updatedb
sudo yum install krb5-libs krb5-server krb5-workstation -y
sudo chmod 777 /etc/krb5.conf
sudo chmod 777 /var/kerberos/*
sudo chmod 777 /var/kerberos/krb5kdc/kdc.conf
sudo chmod 777 /var/kerberos/krb5kdc/kadm5.acl
#sudo chmod 777 /var/log/kadmind.log
#sudo chmod 777 /var/log/krb5kdc.log
#sudo chmod ugo+rw /var/kerberos/krb5kdc/principal
sudo sed -i -e 's/#/ /g' /etc/krb5.conf
sleep 1s
sudo sed -i -e 's/EXAMPLE.COM/IBM.COM/g' /etc/krb5.conf
sleep 1s
sudo sed -i -e "s/kerberos.example.com/${KDCServer}/g" /etc/krb5.conf
sleep 1s
sudo sed -i -e 's/.example.com/.ibm.com/g' /etc/krb5.conf
sleep 1s
sudo sed -i -e 's/example.com/ibm.com/g' /etc/krb5.conf
sleep 1s
sudo sed -i -e 's/24h/72h/g' /etc/krb5.conf
sleep 1s
#echo "renewable = true" >> /etc/krb5.conf
#sleep 2s
sudo sed -i -e 's/EXAMPLE.COM/IBM.COM/g' /var/kerberos/krb5kdc/kdc.conf
sleep 1s
sudo sed -i -e 's/EXAMPLE.COM/IBM.COM/g' /var/kerberos/krb5kdc/kadm5.acl
sleep 1s

cat /etc/krb5.conf
sleep 1s
cat /var/kerberos/krb5kdc/kdc.conf
sleep 1s
cat /var/kerberos/krb5kdc/kadm5.acl
sleep 1s


#create the kerberos database
echo -e "\n this will take some time, please wait for 5min... \n"
echo -e "\n GIVE THE PASSWORD TO THE KERBEROS DATABASE AS admin \n"
sudo /usr/sbin/kdb5_util create -s

sudo /usr/sbin/kadmin.local  -w "admin" -q "addprinc admin/admin@IBM.COM"
sleep 1s
sudo /usr/sbin/kadmin.local  -w "admin" -q "addprinc root/admin@IBM.COM"
sleep 1s

sudo /sbin/service krb5kdc stop
sudo /sbin/service kadmin stop
sudo /sbin/service krb5kdc start
sudo /sbin/service kadmin start

echo "admin" | sudo kinit admin/admin@IBM.COM

sudo /usr/sbin/kadmin.local  -w "admin" -q "list_principals *"
sudo klist

#read -p  "enter an array of fully qualified hostnames other than KDC server separated by space " -a hostnamesArray
IFS=', ' read -r -a hostnamesArray <<< "${lines[1]}"

for ((i=1;i < $num_of_hosts;i++))
{
echo -e "hostname: ${hostnamesArray[$i]}\n"
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo updatedb"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo yum install krb5-libs krb5-workstation -y"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo chmod 777 /etc/krb5.conf"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo chmod 777 /var/kerberos/*"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo chmod 777 /var/kerberos/krb5kdc/kdc.conf"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo chmod 777 /var/kerberos/krb5kdc/kadm5.acl"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo chmod 777 /var/log/kadmind.log"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo chmod 777 /var/log/krb5kdc.log"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo chmod ugo+rw /var/kerberos/krb5kdc/principal"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo sed -i -e 's/#/ /g' /etc/krb5.conf"
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo sed -i -e 's/EXAMPLE.COM/IBM.COM/g' /etc/krb5.conf"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo sed -i -e 's/kerberos.example.com/${KDCServer}/g' /etc/krb5.conf"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo sed -i -e 's/.example.com/.ibm.com/g' /etc/krb5.conf"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo sed -i -e 's/example.com/ibm.com/g' /etc/krb5.conf"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo sed -i -e 's/EXAMPLE.COM/IBM.COM/g' /var/kerberos/krb5kdc/kdc.conf"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "sudo sed -i -e 's/EXAMPLE.COM/IBM.COM/g' /var/kerberos/krb5kdc/kadm5.acl"
sleep 1s
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "cat /etc/krb5.conf"
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "cat /var/kerberos/krb5kdc/kdc.conf"
sshpass -p $rootpassword ssh ${hostnamesArray[$i]}  -t -l root "cat /var/kerberos/krb5kdc/kadm5.acl"
}











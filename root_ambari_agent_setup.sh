#remove root passwordless ssh
#sudo rm -rf /root/.ssh/authorized_keys

path_to_hostdetails=$1

IFS=$'\r\n' GLOBIGNORE='*' command eval  'lines=($(cat $path_to_hostdetails))'
echo -e "ambari repo path: ${lines[4]}\n"
ambari_repo_path=${lines[4]}
echo -e "ambari server: ${lines[6]}\n"
ambarinode=${lines[6]}
sleep 2s

#echo -e "enter the path to the ambari repo file\n"
#read ambari_repo_path
echo -e "your ambari repo path is $ambari_repo_path\n"
wget -P /etc/yum.repos.d $ambari_repo_path
yum repolist all
sleep 2s 
yum -y install ambari-agent
#echo -e "enter the FQDN of ambari node\n"
#read ambarinode

chmod ugo+rwx /etc/ambari-agent/conf/ambari-agent.ini
sudo sed -i -e 's/'"hostname=localhost"'/'"hostname=$ambarinode"'/g' /etc/ambari-agent/conf/ambari-agent.ini
# sed -i -e 's/'"run_as_user=root"'/'"run_as_user=$nonrootuser"'/g' /etc/ambari-agent/conf/ambari-agent.ini
updatedb
/etc/rc.d/init.d/ambari-agent restart
/etc/rc.d/init.d/ambari-agent status

#cleaning repos
yum clean all
yum clean expire-cache
yum clean metadata
yum clean dbcache
rm -Rf /var/cache/yum
updatedb
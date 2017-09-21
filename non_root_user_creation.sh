#create a non root user
#echo -e "enter non root user name\n"
#read nonrootuser
path_to_hostdetails=$1

IFS=$'\r\n' GLOBIGNORE='*' command eval  'lines=($(cat $path_to_hostdetails))'
echo -e "non root user: ${lines[5]}\n"
sleep 2s
nonrootuser=${lines[5]}
echo -e "non root user: ${lines[5]}\n"
nonrootpasswd=${lines[7]}
echo -e "non root password: ${lines[7]}\n"

#enter biginsights stack version
#echo -e "enter BigInsights stack version(e.g. 4.2 or 4.3 etc)\n"
#read BIstackversion

if id "$nonrootuser" >/dev/null 2>&1; then
echo -e "\n user exists, please run the nonRootAmbariSetup.sh script again and give another non root username \n"
echo -e "\n Alternatively you can continue by using the same non root user name which exists\n"

else
echo -e "user does not exist \n"

groupadd -g 15000 $nonrootuser
useradd -u 15000 -g $nonrootuser $nonrootuser
#passwd $nonrootuser
echo $nonrootpasswd | passwd $nonrootuser --stdin
id $nonrootuser

chmod ugo+rw /tmp/installautomation

#modify the /etc/sudoers file
echo -e "# Ambari IOP Customizable Users\n" >> /etc/sudoers;
echo -e "$nonrootuser ALL=(ALL) NOPASSWD:SETENV: /bin/su hdfs *, /bin/su ambari-qa *, /bin/su zookeeper *, /bin/su knox *, /bin/su ams *, /bin/su flume *, /bin/su hbase *, /bin/su spark *, /bin/su hive *, /bin/su hcat *, /bin/su kafka *, /bin/su mapred *, /bin/su oozie *, /bin/su sqoop *, /bin/su storm *, /bin/su yarn *, /bin/su solr *, /bin/su titan *, /bin/su ranger *, /bin/su kms *\n" >> /etc/sudoers;

echo -e "# Ambari value-adds Customizable Users\n" >> /etc/sudoers;
echo -e "$nonrootuser ALL=(ALL) NOPASSWD:SETENV:  /bin/su - bigsheets *,  /bin/su uiuser *,  /bin/su tauser *, /bin/su - bigr *\n" >> /etc/sudoers;

echo -e "# Ambari Non-Customizable Users\n" >> /etc/sudoers;
echo -e "$nonrootuser ALL=(ALL) NOPASSWD:SETENV: /bin/su mysql *\n" >> /etc/sudoers;

echo -e "# Ambari IOP Commands\n" >> /etc/sudoers;
echo -e "$nonrootuser ALL=(ALL) NOPASSWD:SETENV: /usr/bin/yum,/usr/bin/zypper, /usr/bin/apt-get, /bin/mkdir, /usr/bin/test, /bin/ln, /bin/chown, /bin/chmod, /bin/chgrp, /usr/sbin/groupadd, /usr/sbin/groupmod, /usr/sbin/useradd, /usr/sbin/usermod, /bin/cp, /usr/sbin/setenforce, /usr/bin/stat, /bin/mv, /bin/sed,/bin/rm, /bin/kill, /bin/readlink, /usr/bin/pgrep, /bin/cat, /usr/bin/unzip, /bin/tar, /usr/bin/tee, /bin/touch, /usr/bin/iop-select, /usr/bin/conf-select, /usr/iop/current/hadoop-client/sbin/hadoop-daemon.sh, /usr/lib/hadoop/bin/hadoop-daemon.sh, /usr/lib/hadoop/sbin/hadoop-daemon.sh,  /sbin/chkconfig gmond off, /sbin/chkconfig gmetad off, /etc/init.d/httpd *, /sbin/service iop-gmetad start, /sbin/service iop-gmond start,  /usr/sbin/gmond, /usr/sbin/update-rc.d ganglia-monitor *, /usr/sbin/update-rc.d gmetad *, /etc/init.d/apache2 *, /usr/sbin/service iop-gmond *, /usr/sbin/service iopgmetad *, /sbin/service mysqld *, /usr/bin/python2.6, /var/lib/ambari-agent/*, /var/lib/ambari-agent/*/*, /var/lib/ambari-agent/data/tmp/validateKnoxStatus.py *, /usr/iop/current/knox-server/bin/knoxcli.sh *, /usr/bin/dpkg *, /bin/rpm *, /usr/sbin/hst * , /usr/sbin/service mysql *, /usr/sbin/service mariadb *, /usr/bin/ambari-python-wrap, /usr/lib/ambari-infra-solr-client/*\n" >> /etc/sudoers;

echo -e "# Ambari Ranger Commands\n" >> /etc/sudoers;
echo -e "$nonrootuser ALL=(ALL) NOPASSWD:SETENV: /usr/jdk64/*/bin/*, /usr/iop/*/ranger-usersync/setup.sh, /usr/bin/ranger-usersync-stop, /usr/bin/ranger-usersync-start, /usr/iop/*/ranger-admin/setup.sh *, /usr/iop/*/ranger-hbase-plugin/disable-hbase-plugin.sh *, /usr/iop/*/ranger-hdfs-plugin/disable-hdfs-plugin.sh *, /usr/iop/*/ranger-hive-plugin/disable-hive-plugin.sh *, /usr/iop/*/ranger-knox-plugin/disable-knox-plugin.sh *, /usr/iop/*/ranger-yarn-plugin/disable-yarn-plugin.sh *, /usr/iop/current/ranger-kms/ranger_credential_helper.py, /usr/iop/*/ranger-*/ranger_credential_helper.py, /usr/iop/current/ranger-tagsync/lib/*, /usr/iop/current/ranger-tagsync/conf/*\n" >> /etc/sudoers;

echo -e "# Ambari value-adds Commands\n" >> /etc/sudoers;
echo -e "$nonrootuser ALL=(ALL) NOPASSWD:SETENV: /usr/bin/updatedb *, /usr/bin/sh *, /usr/bin/scp *, /usr/bin/pkill *, /bin/unlink *, /usr/bin/mysqld_safe, /usr/bin/mysql_install_db, /usr/bin/R, /usr/bin/Rscript,  /bin/bash, /usr/bin/kinit, /usr/bin/hadoop, /usr/bin/mysqladmin, /usr/sbin/userdel, /usr/sbin/groupdel, /usr/sbin/ambari-server, /usr/bin/klist, /usr/ibmpacks/bin/*/*\n" >> /etc/sudoers;

echo -e "# HDP Commands\n" >> /etc/sudoers;
echo -e "$nonrootuser ALL=(ALL) NOPASSWD:SETENV: /usr/hdp/current/*/sbin/*, /usr/hdp/current/*/bin/*, /var/lib/ambari-agent/cache/extensions/IBM-Big_SQL/*/services/BIGSQL/package/scripts/*, /var/lib/ambari-server/resources/extensions/IBM-Big_SQL/*/services/BIGSQL/package/scripts/*, /var/lib/ambari-agent/cache/stacks/HDP/*/services/BIGSQL/package/scripts/*, /var/lib/ambari-server/resources/stacks/HDP/*/services/BIGSQL/package/scripts/*, /usr/hdp/*/*/*, /var/lib/ambari-server/resources/extensions/BigInsights-BigSQL/*/services/BIGSQL/package/scripts/*, /var/lib/ambari-agent/cache/extensions/BigInsights-BigSQL/*/services/BIGSQL/package/scripts/*,/var/lib/ambari-server/resources/scripts/*, /usr/lib/ambari-logsearch-logfeeder/*\n" >> /etc/sudoers;

echo -e "#generic commands\n" >> /etc/sudoers;
echo -e "Cmnd_Alias BIGSQL_SERVICE_AGNT= /var/lib/ambari-agent/cache/stacks/BigInsights/*/services/BIGSQL/package/scripts/*, /var/lib/ambari-agent/cache/extensions/IBM-Big_SQL/*/services/BIGSQL/package/scripts/*\n" >> /etc/sudoers;
echo -e "Cmnd_Alias BIGSQL_SERVICE_SRVR= /var/lib/ambari-server/resources/stacks/BigInsights/*/services/BIGSQL/package/scripts/*, /var/lib/ambari-server/resources/extensions/IBM-Big_SQL/*/services/BIGSQL/package/scripts/*, /var/lib/ambari-server/resources/extensions/IBM-Big_SQL/*\n" >> /etc/sudoers;
echo -e "Cmnd_Alias BIGSQL_DIST_EXEC=  /usr/ibmpacks/current/bigsql/bigsql/bin/*, /usr/ibmpacks/current/bigsql/bigsql/libexec/*, /usr/ibmpacks/current/bigsql/bigsql/install/*, /usr/ibmpacks/current/IBM-DSM/ibm-datasrvrmgr/bin/*,  /usr/ibmpacks/bin/*/*/*, /usr/ibmpacks/bin/*/*, /usr/ibmpacks/scripts/*/upgrade/BIGSQL/*, /usr/ibmpacks/scripts/*/upgrade/* \n" >> /etc/sudoers;
echo -e "Cmnd_Alias BIGSQL_OS_CALLS= /bin/su, /usr/bin/getent, /usr/bin/id, /usr/bin/ssh, /bin/echo, /usr/bin/scp, /bin/find, /usr/bin/du, /sbin/mkhomedir_helper, /bin/curl\n" >> /etc/sudoers;

echo -e "$nonrootuser ALL=(ALL) NOPASSWD:SETENV:/usr/bin/*, /bin/*, /usr/sbin/*, /sbin/*, /usr/bin/yum,/usr/bin/zypper,/usr/bin/apt-get, /bin/mkdir, /bin/ln,/bin/chown, /bin/chmod, /bin/chgrp, /usr/sbin/groupadd, /usr/sbin/groupmod,/usr/sbin/useradd, /usr/sbin/usermod, /bin/cp, /bin/sed, /bin/mv, /bin/rm, /bin/kill,/usr/bin/unzip, /bin/tar, /usr/bin/*-select, /usr/iop/current/hadoop-client/sbin/hadoop-daemon.sh,/usr/lib/hadoop/bin/hadoop-daemon.sh, /usr/lib/hadoop/sbin/hadoop-daemon.sh, /usr/sbin/service mysql *,/sbin/service mysqld *, /sbin/service mysql *, /sbin/chkconfig gmond off,/sbin/chkconfig gmetad off, /etc/init.d/httpd *, /sbin/service iop-gmetad start, /sbin/service iop-gmond start, /usr/bin/tee, /usr/sbin/gmond, /usr/sbin/update-rc.d ganglia-monitor *, /usr/sbin/update-rc.d gmetad *, /etc/init.d/apache2 *, /usr/sbin/service iop-gmond *, /usr/sbin/service iopgmetad *, /usr/bin/test, /bin/touch, /usr/bin/stat, /usr/sbin/setenforce, /usr/bin/ambari-python-wrap, /bin/readlink,  /usr/sbin/service mariadb *, /usr/bin/R, /usr/bin/Rscript, /tmp/installautomation/*/bin/*, BIGSQL_SERVICE_AGNT, BIGSQL_SERVICE_SRVR, BIGSQL_DIST_EXEC, BIGSQL_OS_CALLS\n" >> /etc/sudoers;


echo -e "Defaults exempt_group = $nonrootuser\n" >> /etc/sudoers;
echo -e "Defaults !env_reset,env_delete-=PATH\n" >> /etc/sudoers;
echo -e "Defaults: $nonrootuser !requiretty\n" >> /etc/sudoers;

fi
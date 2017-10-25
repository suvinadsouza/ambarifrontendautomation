#Enablenable Ambari with HTTPS: Self signed certificate : To create certificate, issue following commands:

 ambarihost=$1

 updatedb
 openssl genrsa -out /tmp/installautomation/$ambarihost.key 2048
 openssl req -new -key /tmp/installautomation/$ambarihost.key -out /tmp/installautomation/$ambarihost.csr
 openssl x509 -req -days 365 -in /tmp/installautomation/$ambarihost.csr -signkey /tmp/installautomation/$ambarihost.key -out /tmp/installautomation/$ambarihost.crt
 /etc/rc.d/init.d/ambari-server setup-security
 /etc/rc.d/init.d/ambari-server restart
 /etc/rc.d/init.d/ambari-server status

 openssl x509 -in /tmp/installautomation/$ambarihost.crt -out /tmp/installautomation/$ambarihost.pem -outform pem
 cp /tmp/installautomation/$ambarihost.pem /etc/pki/ca-trust/source/anchors/

 update-ca-trust enable
 update-ca-trust extract

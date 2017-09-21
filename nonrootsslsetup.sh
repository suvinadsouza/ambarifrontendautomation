#Enablenable Ambari with HTTPS: Self signed certificate : To create certificate, issue following commands:

ambarihost=$1

sudo updatedb
sudo openssl genrsa -out /tmp/installautomation/$ambarihost.key 2048
sudo openssl req -new -key /tmp/installautomation/$ambarihost.key -out /tmp/installautomation/$ambarihost.csr
sudo openssl x509 -req -days 365 -in /tmp/installautomation/$ambarihost.csr -signkey /tmp/installautomation/$ambarihost.key -out /tmp/installautomation/$ambarihost.crt
sudo /etc/rc.d/init.d/ambari-server setup-security
sudo /etc/rc.d/init.d/ambari-server restart
sudo /etc/rc.d/init.d/ambari-server status

sudo openssl x509 -in /tmp/installautomation/$ambarihost.crt -out /tmp/installautomation/$ambarihost.pem -outform pem
sudo cp /tmp/installautomation/$ambarihost.pem /etc/pki/ca-trust/source/anchors/

sudo update-ca-trust enable
sudo update-ca-trust extract

MASTER_NODE=rink1.fyre.ibm.com
ENCRYPTION="aes128-cts:normal"
NODE_LIST="rink2.fyre.ibm.com
rink3.fyre.ibm.com
rink4.fyre.ibm.com
rink5.fyre.ibm.com"

### hive orchestrator zookeeper user1 ###
for _service in bigsql; do

echo >> /tmp/genkey.${MASTER_NODE}
for _node in $MASTER_NODE $NODE_LIST; do
echo addprinc -randkey -e ${ENCRYPTION} $_service/${_node}@IBM.COM >> /tmp/genkey.$MASTER_NODE
echo ktadd -norandkey -k $_service.${_node}.keytab $_service/${_node}@IBM.COM >> /tmp/genkey.$MASTER_NODE
done

done

echo " #######   HELLO #########"
cat /tmp/genkey.${MASTER_NODE}

echo " #######   HELLO1 #########"

cat /tmp/genkey.${MASTER_NODE} | sudo kadmin.local

echo " #######   HELLO2 #########"

sudo chmod go+r *.keytab

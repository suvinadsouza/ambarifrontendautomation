password=$1
username=$2
ssh-keygen
sleep 1s
for n in `cat /tmp/installautomation/nodeList`
do
sshpass -p $password ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub $username@$n
sleep 2s
done
for n in `cat /tmp/installautomation/nodeList`
do
sshpass -p $password ssh -o StrictHostKeyChecking=no $username@$n date
done

sudo yum -y update
sudo yum -y install docker
sudo usermod -a -G docker ec2-user
sudo chkconfig iptables off
sudo service docker start
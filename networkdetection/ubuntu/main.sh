#get docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

#setup networking
wget https://raw.githubusercontent.com/BoredHackerBlog/vultrlabscripts/main/networkdetection/ubuntu/00-installer-config.yaml -O /etc/netplan/00-installer-config.yaml
netplan apply


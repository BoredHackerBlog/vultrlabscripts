#get docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

#setup networking
wget https://raw.githubusercontent.com/BoredHackerBlog/vultrlabscripts/main/logdetection/ubuntu/00-installer-config.yaml -O /etc/netplan/00-installer-config.yaml
netplan apply

#start humio
mkdir -p /humio/mounts/humio /humio/mounts/kafka-data /humio/mounts/data
docker run -d -v /humio/mounts/data:/data -v /humio/mounts/kafka-data:/data/kafka-data -v /humio/mounts/humio:/etc/humio:ro --net=host -p 8080:8080 --ulimit="nofile=8192:8192" humio/humio:1.25.3

#setup humio
wget https://raw.githubusercontent.com/BoredHackerBlog/vultrlabscripts/main/logdetection/ubuntu/setup_humio.py
python3 setup_humio.py


#get docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

#setup docker compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

#setup networking
wget https://raw.githubusercontent.com/BoredHackerBlog/vultrlabscripts/main/networkdetection/ubuntu/00-installer-config.yaml -O /etc/netplan/00-installer-config.yaml
netplan apply

#setup suricata
mkdir suricata
cd suricata
wget https://raw.githubusercontent.com/BoredHackerBlog/vultrlabscripts/main/networkdetection/ubuntu/docker-compose.yml
docker-compose up -d
sleep 15
docker exec -it --user suricata suricata suricata-update update-sources
docker exec -it --user suricata suricata suricata-update enable-source oisf/trafficid
docker exec -it --user suricata suricata suricata-update enable-source et/open
docker exec -it --user suricata suricata suricata-update enable-source ptresearch/attackdetection
docker exec -it --user suricata suricata suricata-update enable-source sslbl/ssl-fp-blacklist
docker exec -it --user suricata suricata suricata-update enable-source tgreen/hunting
docker exec -it --user suricata suricata suricata-update --no-test


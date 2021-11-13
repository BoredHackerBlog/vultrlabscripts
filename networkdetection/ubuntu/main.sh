#disable fw
ufw disable

#get docker
ip link add name docker0 type bridge
ip addr add dev docker0 172.17.0.1/16
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
docker run -d --rm -it --name suricata --net=host --cap-add=net_admin --cap-add=sys_nice -v $(pwd)/logs:/var/log/suricata jasonish/suricata:latest -i enp6s0

docker run -d --rm -it --name evebox -v $(pwd)/logs:/var/log/suricata:ro -v $(pwd)/evebox:/evebox -p 5636:5636 jasonish/evebox:latest -D /evebox/ --datastore sqlite --input /var/log/suricata/eve.json

sleep 15
docker exec -it --user suricata suricata suricata-update update-sources
docker exec -it --user suricata suricata suricata-update enable-source oisf/trafficid
docker exec -it --user suricata suricata suricata-update enable-source et/open
docker exec -it --user suricata suricata suricata-update enable-source ptresearch/attackdetection
docker exec -it --user suricata suricata suricata-update enable-source sslbl/ssl-fp-blacklist
docker exec -it --user suricata suricata suricata-update enable-source tgreen/hunting
docker exec -it --user suricata suricata suricata-update --no-test



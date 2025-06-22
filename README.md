# Install Chromium Linux Browser
Chromium is an open-source browser project that aims to build a safer, faster, and more stable build by Google
* You can easily access a browser in your non-gui Linux server
* You can easily run your Node Extensions 

## Install Docker
```console
sudo apt update -y && sudo apt upgrade -y
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y && sudo apt upgrade -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker version check
docker --version
```

## Timezone check
```
realpath --relative-to /usr/share/zoneinfo /etc/localtime
```

## Install Chromium
**1. Create directory**
```
mkdir chromium
cd chromium
```

**2. Create `docker-compose.yaml` file**
```
nano generate-compose.sh
```

**3. Paste the following code in it**
* `CUSTOM_USER` & `PASSWORD`: Replace your favorite credentials to login to chromium
* `TZ`: Replace with your server timezone
* `CHROME_CLI`: The main page when you open browser
* `ports`: You can replace `3010` & `3011` if they have conflict
```
#!/bin/bash

NUM_CONTAINERS=10  # thay số lượng container tại đây

echo "version: '3'" > docker-compose.gen.yml
echo "services:" >> docker-compose.gen.yml

for i in $(seq 1 $NUM_CONTAINERS); do
  PORT1=$((3000 + i * 10))
  PORT2=$((3001 + i * 10))

  cat <<EOF >> docker-compose.gen.yml
  chromium_$i:
    image: lscr.io/linuxserver/chromium:latest
    container_name: chromium_$i
    security_opt:
      - seccomp:unconfined
    environment:
      - CUSTOM_USER=admin
      - PASSWORD=abcd1234
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Bangkok
      - CHROME_CLI=https://github.com/Hoanghienvi
    volumes:
      - /root/chromium/config_$i:/config
    ports:
      - "$PORT1:3000"
      - "$PORT2:3001"
    shm_size: "1gb"
    restart: unless-stopped

EOF
done

```
> To save and exit: `Ctrl+X+Y+Enter` 

## Run Chromium
```console
chmod +x generate-compose.sh
./generate-compose.sh
docker compose -f docker-compose.gen.yml up -d
```
**The application can be accessed by going to one of these addresses in your local PC browser**
* http://Server_IP:3010/
* https://Server_IP:3011/

## Optional: Stop and Delete Chromium
```
docker stop chromium
docker rm chromium
docker system prune
```

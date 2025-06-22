#!/bin/bash

NUM=10  # số container bạn muốn tạo

echo "version: '3'" > docker-compose.gen.yml
echo "services:" >> docker-compose.gen.yml

for i in $(seq 1 $NUM); do
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

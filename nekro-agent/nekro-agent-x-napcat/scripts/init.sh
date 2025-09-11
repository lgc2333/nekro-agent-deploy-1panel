#!/bin/bash
docker pull kromiose/nekro-agent-sandbox:latest
echo "Successfully pulled the sandbox image"

# shellcheck disable=SC2046
export $(cat .env | xargs)

replacing_files=(
  "./data/configs/onebot_v11/config.yaml"
  "./data/napcat_data/napcat/onebot11.json"
  "./data/napcat_data/napcat/webui.json"
)
for file_path in "${replacing_files[@]}"; do
  if [ -f "$file_path" ]; then
    temp_file=$(mktemp)
    envsubst <"$file_path" >"$temp_file" && mv "$temp_file" "$file_path"
    echo "Successfully replaced vars in $file_path"
  else
    echo "Warning: File not found: $file_path"
  fi
done

if [ -n "$NAPCAT_QQ" ]; then
  old_file="./data/napcat_data/napcat/onebot11.json"
  new_file="./data/napcat_data/napcat/onebot11_${NAPCAT_QQ}.json"
  if [ -f "$old_file" ]; then
    mv "$old_file" "$new_file"
    echo "Renamed $old_file to $new_file"
  else
    echo "Warning: $old_file not found, skipping rename."
  fi
fi

if [ -z "$NAPCAT_CONTAINER_MAC_ADDRESS" ]; then
  echo "NAPCAT_CONTAINER_MAC_ADDRESS is not set, generating a random one..."
  if ! command -v openssl &>/dev/null; then
    echo "openssl command could not be found, please install it first."
    exit 1
  fi
  random_mac="02:$(openssl rand -hex 5 | sed 's/\(..\)/\1:/g; s/.$//')"

  if [ ! -f ".env" ]; then
    touch .env
  fi

  # Remove existing NAPCAT_CONTAINER_MAC_ADDRESS line if it exists, then append the new one
  grep -v "^NAPCAT_CONTAINER_MAC_ADDRESS=" .env >.env.tmp && mv .env.tmp .env
  echo "NAPCAT_CONTAINER_MAC_ADDRESS=$random_mac" >>.env
  echo "Successfully added random MAC address to .env ($random_mac)"
fi

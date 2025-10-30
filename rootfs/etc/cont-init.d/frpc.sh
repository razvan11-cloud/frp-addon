#!/usr/bin/with-contenv bashio

# This script runs once when the add-on starts

# Get the unique ID from the user's configuration
bashio::log.info "Reading configuration..."
UNIQUE_ID=$(bashio::config 'unique_id')

# Validate that the user actually entered something
if [[ -z "${UNIQUE_ID}" ]]; then
  bashio::log.fatal "The 'unique_id' is empty! Please enter the key provided by your service."
  bashio::exit.nok
fi

# Create the frpc.toml file in a persistent location
CONFIG_PATH=/data/frpc.toml
bashio::log.info "Generating frpc configuration at ${CONFIG_PATH}..."
cat << EOF > "${CONFIG_PATH}"
serverAddr = "YOUR_CLOUD_SERVER_IP"
serverPort = 7000
auth.token = "A_VERY_STRONG_GLOBAL_TOKEN_FOR_ALL_CLIENTS"

[[proxies]]
name = "ha-proxy-${UNIQUE_ID}"
type = "http"
localIp = "127.0.0.1"
localPort = 8123
subdomain = "${UNIQUE_ID}"
EOF
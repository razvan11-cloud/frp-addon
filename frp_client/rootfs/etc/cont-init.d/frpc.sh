# This script runs once when the add-on starts

# Get the unique ID from the user's configuration
bashio::log.info "Reading configuration..."
SERVER_ADDR=$(bashio::config 'server_address')
AUTH_TOKEN=$(bashio::config 'auth_token')
UNIQUE_ID=$(bashio::config 'unique_id')

# Validate that the user actually entered something
if [[ -z "${SERVER_ADDR}" || -z "${AUTH_TOKEN}" || -z "${UNIQUE_ID}" ]]; then
  bashio::log.fatal "Configuration is incomplete! Please fill in all fields: server_address, auth_token, and unique_id."
  bashio::exit.nok
fi

# Create the frpc.toml file in a persistent location
CONFIG_PATH=/data/frpc.toml
bashio::log.info "Generating frpc configuration..."
cat << EOF > "${CONFIG_PATH}"
serverAddr = "${SERVER_ADDR}"
serverPort = 7000
auth.token = "${AUTH_TOKEN}"

[[proxies]]
name = "ha-proxy-${UNIQUE_ID}"
type = "http"
localIp = "127.0.0.1"
localPort = 8123
subdomain = "${UNIQUE_ID}"

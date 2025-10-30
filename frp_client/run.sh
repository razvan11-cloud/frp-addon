#!/usr/bin/with-contenv bashio

# This script is the main process of the add-on. It runs after the init scripts.
CONFIG_PATH=/data/frpc.toml

bashio::log.info "Starting frpc client..."
# Execute frpc using the generated config file
/usr/bin/frpc -c "${CONFIG_PATH}"
#!/bin/sh

# addresses
dockerize -wait file://${DEPLOYMENT_PATH} -timeout 300s
echo "Extracting deployment information for contract \"${DAPP_CONTRACT_NAME}\" from ${DEPLOYMENT_PATH}"
DAPP_CONTRACT_ADDRESS=$(jq -r ".contracts[\"${DAPP_CONTRACT_NAME:-CartesiDApp}\"].address" ${DEPLOYMENT_PATH})

# wait for services
dockerize -wait tcp://${STATE_SERVER_HOSTNAME}:${STATE_SERVER_PORT} \
          -wait tcp://${SERVER_MANAGER_HOSTNAME}:${SERVER_MANAGER_PORT} \
          -timeout 300s

/usr/local/bin/offchain_main \
  --dapp-contract-address $DAPP_CONTRACT_ADDRESS \
  --logic-config-path $LOGIC_CONFIG_PATH \
  --sf-config $STATE_FOLD_CONFIG_PATH \
  --bs-config $BLOCK_SUBSCRIBER_CONFIG_PATH \
  --tm-config $TX_MANAGER_CONFIG_PATH

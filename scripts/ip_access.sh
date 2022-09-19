#!/bin/bash

#IP_ADDR='80.87.25.49'
IP_ADDR='54.171.84.161'
IP_ADDR_RANGE="$IP_ADDR/32"
RESOURCE_GROUP_BASE='oasis-workshop'

for i in {1..20}
do
    RESOURCE_GROUP=${RESOURCE_GROUP_BASE}-$i
    echo "--- $RESOURCE_GROUP ---"

    # Find storage Account + Add IP
    VAULT_NAME=$(az keyvault list -g $RESOURCE_GROUP --query '[?"tags.oasis-enterprise" == "True"].name'  -o tsv | head -n 1)
    STORAGE_ACC=$(az keyvault secret show --vault-name $VAULT_NAME --name oasisfs-name --query "value" -o tsv)
    az storage account network-rule add -g $RESOURCE_GROUP --account-name $STORAGE_ACC --ip-address $IP_ADDR

    # Add IP to cluster ingress
    CURRENT_IP_RANGE=$( az network nsg rule show  --resource-group $RESOURCE_GROUP  --nsg-name  oasis-enterprise-vnet-sg  --name HTTPS-IP-Allow | jq ' .sourceAddressPrefixes | join(" ")' | tr -d '"')
    NEW_IP_RANGE="$CURRENT_IP_RANGE $IP_ADDR_RANGE"
    echo $NEW_IP_RANGE

    if [ $(echo $CURRENT_IP_RANGE | grep -c $IP_ADDR_RANGE ) -gt 0 ]; then
        echo "IP $IP_ADDR_RANGE in range - SKIP"
    else
        az network nsg rule update --resource-group $RESOURCE_GROUP --nsg-name  oasis-enterprise-vnet-sg --name HTTPS-IP-Allow --source-address-prefixes $NEW_IP_RANGE
    fi
done

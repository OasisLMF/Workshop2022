#!/bin/bash

RESOURCE_GROUP_BASE='oasis-workshop'
LOCATION='northcentralus'
AzureDeplpy='/home/sam/work-dir/oasis-azure/OasisAzureDeployment'

for i in {1..20}
do
    export RESOURCE_GROUP=${RESOURCE_GROUP_BASE}-$i
    export DNS_LABEL_NAME=${RESOURCE_GROUP_BASE}-$i

    # Delete exising group
    az group delete -yn ${RESOURCE_GROUP_BASE}-$i

    # init new group
    az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --tags oasis-enterprise=True
    az feature register --name EnablePodIdentityPreview --namespace Microsoft.ContainerService
    az extension add --name aks-preview

    # run deploy 
    $AzureDeplpy/deploy.sh base

    # Add user as owner  
    az role assignment create --role "Owner" --assignee "workshop$i@oasislmfenterprise.onmicrosoft.com" --resource-group "oasis-workshop-$i"
    az role assignment create --role "Owner" --assignee "workshop$i@oasislmfenterprise.onmicrosoft.com" --resource-group "oasis-workshop-$i-aks"
done    

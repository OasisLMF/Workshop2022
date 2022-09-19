#!/bin/bash

for i in {1..20}
do
    #az role assignment create --role "Owner" --assignee "workshop$i@oasislmfenterprise.onmicrosoft.com" --resource-group "oasis-workshop-$i"
    #az role assignment create --role "Owner" --assignee "workshop$i@oasislmfenterprise.onmicrosoft.com" --resource-group "oasis-workshop-$i-aks"


    az role assignment create --role "Key Vault Administrator" --assignee "workshop$i@oasislmfenterprise.onmicrosoft.com" --scope "/subscriptions/da90aaa5-0e0f-4362-bb41-422887865d0f/resourcegroups/oasis-workshop-$i"


    #az role assignment create --role "Contributor" --assignee "workshop$i@oasislmfenterprise.onmicrosoft.com" --resource-group "cloud-shell-storage-westeurope"
    #az role assignment create --role "Contributor"      --assignee "workshop$i@oasislmfenterprise.onmicrosoft.com" --resource-group "model-data-storage"
done

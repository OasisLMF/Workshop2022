#!/bin/bash


az login --identity

#RESOURCE_GROUP=oasis-workshop-1
RESOURCE_GROUP=oasis-workshop-$(echo $USER | tr -dc '0-9')
#VAULT_NAME=$(az keyvault list -g $RESOURCE_GROUP --query '[?"tags.oasis-enterprise" == "True"].name'  -o tsv | head -n 1)
#STORAGE_ACC=$(az keyvault secret show --vault-name $VAULT_NAME --name oasisfs-name --query "value" -o tsv)
STORAGE_ACC=oasisnfimtzbjucel

TOKEN_END=$(date -u -d "300 minutes" '+%Y-%m-%dT%H:%MZ')
CONTAINER_SAS_TOKEN=$(az storage container generate-sas --account-name oasismodelstore --name columbia-chaz  --permissions acdlrw --expiry $TOKEN_END | tr -d '"')
SHARE_SAS_TOKEN="$(az storage share generate-sas --name models --account-name $STORAGE_ACC  --expiry $TOKEN_END --permissions lrw | tr -d '"')"


echo $SHARE_SAS_TOKEN

#./azcopy copy "https://oasismodelstore.blob.core.windows.net/columbia-chaz/*?$CONTAINER_SAS_TOKEN" "https://$STORAGE_ACC.file.core.windows.net/models/columbia/chaz/1?$SHARE_SAS_TOKEN" --recursive=true --overwrite=ifSourceNewer 

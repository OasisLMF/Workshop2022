#!/bin/bash


# cloud access vars
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=


OASIS_FS_ACCOUNT_NAME="oasismodelstore"
BUCKET_URL="https://oasislmf-model-library-columbia-chaz.s3.eu-west-1.amazonaws.com/"
BUCKET_NAME="columbia-chaz"

# Create tokens
TOKEN_END=$(date -u -d "300 minutes" '+%Y-%m-%dT%H:%MZ')
CONTAINER_SAS_TOKEN=$(az storage container generate-sas --account-name $OASIS_FS_ACCOUNT_NAME  --name $BUCKET_NAME --permissions acdlrw --expiry $TOKEN_END | tr -d '"')
SHARE_SAS_TOKEN="$(az storage share generate-sas --name models --account-name $OASIS_FS_ACCOUNT_NAME  --expiry $TOKEN_END --permissions lrw | tr -d '"')"


if [ ! -f azcopy ]; then
    echo "  Downloading azcopy binary"
    pushd /tmp
        wget -c https://aka.ms/downloadazcopy-v10-linux -O - | tar -xz 
        TAR_DIR=$PWD/$(ls | grep azcopy_linux)
        BIN_FILE=$TAR_DIR/azcopy
    popd
    cp $TAR_DIR/azcopy .
fi  


# Copy data from S3 -> Blob storage (direct copy to fileshare not supported)
az login
az storage container create -n $BUCKET_NAME --account-name $OASIS_FS_ACCOUNT_NAME
./azcopy copy "$BUCKET_URL"   "https://$OASIS_FS_ACCOUNT_NAME.blob.core.windows.net/$BUCKET_NAME?$CONTAINER_SAS_TOKEN" --recursive

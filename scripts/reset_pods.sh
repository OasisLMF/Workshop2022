#!/bin/bash


for i in {2..20}
do

    echo " --- CLUSTER oasis-workshop-$i --- "

    az aks get-credentials --resource-group oasis-workshop-$i --name oasis-enterprise --overwrite-existing --only-show-errors
    kubectl get pods

    echo '==Reset pods=='
    container_list=$(kubectl get pods | grep oasis- | awk 'BEGIN { FS = "[ \t\n]+" }{ print $1 }')
    echo $container_list | xargs -r kubectl delete pod
done    

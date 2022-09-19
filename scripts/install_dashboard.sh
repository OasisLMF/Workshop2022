#!/bin/bash

# (from  https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.1/aio/deploy/recommended.yaml)
kubectl apply -f ../kube_config/kube-dashboard.yaml

# Add service account (and grant admin?)
kubectl create serviceaccount dashboard
kubectl create clusterrolebinding dashboard-admin  --clusterrole=cluster-admin  --serviceaccount=default:dashboard

# Open access via ingress
kubectl apply -f  ../kube_config/ingress-dashboard.yaml


# create access token
kubectl create token dashboard

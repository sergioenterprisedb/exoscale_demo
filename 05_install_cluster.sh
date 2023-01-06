#!/bin/bash

. ./config.sh


printf "${green}kubectl create secret generic minio-creds --from-literal=SKS_ACCESS_KEY=admin --from-literal=SKS_SECRET_KEY=password${reset}\n"

#SKS secrets
kubectl create secret generic sks-creds \
  --from-literal=SKS_ACCESS_KEY=<your_access_key> \
  --from-literal=SKS_SECRET_KEY=<your_secret_key>

printf "${green}kubectl apply -f cluster-example.yaml${reset}\n"

kubectl apply -f cluster-example.yaml

#!/bin/bash

kubectl delete cluster cluster-example-13
kubectl delete cluster cluster-example-14
kubectl delete cluster cluster-example-15
kubectl delete cluster cluster-example
kubectl delete cluster cluster-restore

kubectl delete -f backup.yaml


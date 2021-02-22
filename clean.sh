#!/bin/bash
#Install dashboard
echo "Destroying dashboard..."
kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.1.0/aio/deploy/recommended.yaml

#Clean up user credentials
echo "Cleaning up old credentials..."
kubectl -n kubernetes-dashboard delete serviceaccount admin-user
kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user

#Install metrics server
echo "Uninstalling metrics-server..."
kubectl delete -f k8s-dashboard.yaml
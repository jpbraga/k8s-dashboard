#!/bin/bash

#Install dashboard
echo "Installing dashboard..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.1.0/aio/deploy/recommended.yaml

#Clean up user credentials
echo "\n\nCleaning up old credentials..."
kubectl -n kubernetes-dashboard delete serviceaccount admin-user
kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user

#Create new credentials
echo "\n\nCreating new credentials..."
kubectl apply -f k8s-dashboard-adminuser.yaml
kubectl apply -f k8s-cluster-role-binding.yaml

#Install metrics server
echo "\n\nInstalling metrics-server..."
kubectl apply -f k8s-dashboard.yaml

sleep 5s
echo "\n\nOpening up dashboard url..."
open http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" | pbcopy
echo "\nStarting up dashboard server..."
kubectl proxy
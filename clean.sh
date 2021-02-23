#!/bin/bash

#Style vars
bold=$(tput bold)
normal=$(tput sgr0)

#Uninstall dashboard
echo -e "\n${bold}Destroying dashboard...${normal}"
kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.1.0/aio/deploy/recommended.yaml --ignore-not-found=true

#Clean up user credentials
echo -e "\n${bold}Cleaning up old credentials...${normal}"
kubectl -n kubernetes-dashboard delete serviceaccount admin-user --ignore-not-found=true
kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user --ignore-not-found=true

#Install metrics server
echo -e "\n${bold}Uninstalling metrics-server...${normal}"
kubectl delete -f k8s-dashboard.yaml --ignore-not-found=true
#!/bin/bash

#Style vars
bold=$(tput bold)
normal=$(tput sgr0)

#Install dashboard
echo -e "\n\n${bold}Installing dashboard...${normal}"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.1.0/aio/deploy/recommended.yaml

#Create new credentials
echo -e "\n\n${bold}Verifying credentials...${normal}"
serviceaccount=$(kubectl -n kubernetes-dashboard get serviceaccount admin-user --ignore-not-found=true | grep admin-user)
clusterrolebinding=$(kubectl -n kubernetes-dashboard get clusterrolebinding admin-user --ignore-not-found=true | grep admin-user)
if [[ -z $serviceaccount ]]; then
    echo -e "\n${bold}Creating a new service account admin-user...${normal}"
    kubectl apply -f k8s-dashboard-adminuser.yaml
fi

if [[ -z $clusterrolebinding ]]; then
    echo -e "\n${bold}Creating a new cluster role binding for the admin-user...${normal}"
    kubectl apply -f k8s-cluster-role-binding.yaml
fi

if [[ -n $clusterrolebinding && -n $serviceaccount ]]; then
    echo -e "Service account admin-user and cluster role binding are already in place!"
fi

#Install metrics server
echo -e "\n\n${bold}Installing metrics-server...${normal}"
kubectl apply -f k8s-dashboard.yaml

#Waiting for the initialization
echo -e "\n\n${bold}Waiting for the dashboard to start...${normal}"
count=1
while [ $count -le 10 ]; do

    dpod=$(kubectl -n kubernetes-dashboard get pods -l k8s-app=kubernetes-dashboard | grep Running)
    if [[ -n $dpod ]]; then
        break
    fi

    fpod=$(kubectl -n kubernetes-dashboard get pods -l k8s-app=kubernetes-dashboard | grep Failed)
    if [[ -n $fpod ]]; then
        echo -e "${bold}There was an error while starting up the dashboard - see the log bellow${normal}\n"
        echo $(kubectl -n kubernetes-dashboard logs -l k8s-app=kubernetes-dashboard)
        exit 1
    fi
    echo "Waiting for the dashboard to start..."
    count=$(($count + 1))
    sleep 1s
done
if [[ $count -gt 10 ]]; then
    echo "${bold}It may not have been fully initialized. The dashboard pod's current state is: ${normal}"
    kubectl -n kubernetes-dashboard get pods -l k8s-app=kubernetes-dashboard
fi

echo -e "\n${bold}Access token copied to clipboard...${normal}"
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" | pbcopy

echo -e "\n${bold}Opening up dashboard url...${normal}"
open http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

echo -e "\n${bold}Starting up dashboard server...${normal}"
kubectl proxy

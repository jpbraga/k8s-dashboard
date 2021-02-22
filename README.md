# Kubernetes Dashboard
![Kubernetes Dashboard](https://img.shields.io/badge/kubernetes%20dashboard-2.1.0-green)
![Metrics server](https://img.shields.io/badge/metrics%20server-latest-green)


## Sumário
- [Project](#project)
- [Requirements](#requirements)
- [How to use](#how-to-use)
- [Take it down](#take-it-down)
- [Issues](#issues)


## Project
This projects aims to be a quick start for the Kubernetes dashboard
[K8s Web UI](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)


## Requirements
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Kubernetes](https://kubernetes.io/docs/setup/)


## How to use
1. Execute in the same directory as the repository content
    ```
    bash setup.sh
    ```
    
2. If everything goes well, it will open your default browser with the Token copied into your clipboard

3. Paste the token into the token auth option and submit.


## Take it down
1. Execute in the same directory as the repository content
    ```
    bash clean.sh
    ```
## Issues
1. If for any reason when executing the ```bash setup.sh``` to install and start up the dashboard, the web browser opens up with it already logged in and with no information regarding the cluster being displayed, just sign out and login again with the token aready copied into the clipboard

## Pre-requisites
1. Azure account - Use [Visual Studio Enterprise Subscription](https://my.visualstudio.com/Subscriptions?mkt=en-us)
2. Windows Subsystem for Linux - Enable this in "Add/Remove Windows Features"
2. Docker Desktop - [Download](https://www.docker.com/products/docker-desktop)
3. Azure CLI - [Download](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) or Run `winget install -e --id Microsoft.AzureCLI`
4. Helm - https://helm.sh/docs/intro/install/#from-the-binary-releases

## Aliasing kubectl
```bash
# powershell
Set-Alias -Name k -Value kubectl

# Mac/Linux
alias k="kubectl"
```

## Create resource group, AKS cluster and Azure Container Registry
```bash
# https://microsoft.com/devicelogin
az login --use-device-code
az account set --subscription <sub guid>

az group create --name rg-aks-learn --location southeastasia

kubectl create namespace my-nginx-ingress
kubectl create namespace my-aks-app

# az aks create --resource-group rg-aks-learn --name aks-learn --node-count 1 --enable-addons monitoring --generate-ssh-keys
az aks create --resource-group rg-aks-learn --name aks-learn --node-count 1 --enable-addons monitoring --generate-ssh-keys --vm-set-type VirtualMachineScaleSets --node-vm-size standard_ds2

az aks get-credentials --resource-group rg-aks-learn --name aks-learn
kubectl get nodes

az acr create --resource-group rg-aks-learn --name ravpawarakslearn --sku Basic --admin-enabled true
```

## Build and push docker image to Azure Container Registry
```bash
git clone https://github.com/rav-pawar/aks-learn.git

docker login ravpawarakslearn.azurecr.io # Username: ravpawarakslearn , Password: password

cd aks-learn/App/v1
docker build -t ravpawarakslearn.azurecr.io/aks-learn:v1.0 . ; docker push ravpawarakslearn.azurecr.io/aks-learn:v1.0

az acr repository list --name ravpawarakslearn --output table
az acr repository show-tags --name ravpawarakslearn --repository aks-learn --output table

kubectl delete secret docker-registry acr-secret
kubectl create -n my-aks-app secret docker-registry acr-secret --docker-server=ravpawarakslearn.azurecr.io --docker-username=ravpawarakslearn --docker-password=password --docker-email=ravpawar@hotmail.com

kubectl get secret acr-secret -o jsonpath="{.data.\.dockerconfigjson}" 
# decrypt using - www.base64decode.org

```

## Deploy application to AKS cluster
```bash

cd aks-learn/Deployments/
kubectl apply -f deploy.yml

kubectl delete deployment web-deploy # to remove deployment

cd aks-learn/Services/
kubectl apply -f svc-lb.yml

```


To get username and password for Azure Container Registry - [Click here](https://portal.azure.com/#@ravpawarhotmail.onmicrosoft.com/resource/subscriptions/130ac2c4-7738-417c-ac84-be52935d892f/resourceGroups/rg-aks-learn/providers/Microsoft.ContainerRegistry/registries/ravpawarakslearn/accessKey)
![To get username and password for Azure Container Registry](acr-access-keys.png)


---


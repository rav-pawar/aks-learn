## Pre-requisites
1. Azure account - Use [Visual Studio Enterprise Subscription](https://my.visualstudio.com/Subscriptions?mkt=en-us)
2. Windows Subsystem for Linux - Enable this in "Add/Remove Windows Features"
2. Docker Desktop - [Download](https://www.docker.com/products/docker-desktop)
3. Azure CLI - [Download](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) or Run `winget install -e --id Microsoft.AzureCLI`
4. Helm - https://helm.sh/docs/intro/install/#from-the-binary-releases

## Create resource group, AKS cluster and Azure Container Registry
```bash
# https://microsoft.com/devicelogin
az login --use-device-code

az group create --name rg-aks-learn --location southeastasia

az aks create --resource-group rg-aks-learn --name aks-learn --node-count 3 --enable-addons monitoring --generate-ssh-keys

az aks get-credentials --resource-group rg-aks-learn --name aks-learn

kubectl get nodes

az acr create --resource-group rg-aks-learn --name ravpawarakslearn --sku Basic --admin-enabled true
```

## Build and push docker image to Azure Container Registry
```bash
docker login ravpawarakslearn.azurecr.io # Username: ravpawarakslearn , Password: password

git clone https://github.com/rav-pawar/aks-learn.git

cd aks-learn/App/v1

docker build -t ravpawarakslearn.azurecr.io/aks-learn:v1.0 .

docker push ravpawarakslearn.azurecr.io/aks-learn:v1.0

az acr repository list --name ravpawarakslearn --output table

az acr repository show-tags --name ravpawarakslearn --repository aks-learn --output table


```

## Deploy application to AKS cluster
```bash
kubectl create secret docker-registry acr-secret \
  --docker-server=ravpawarakslearn.azurecr.io \
  --docker-username=ravpawarakslearn \
  --docker-password=password \
  --docker-email=ravpawar@hotmail.com

git clone https://github.com/rav-pawar/aks-learn.git

cd aks-learn/Deployments/

kubectl apply -f deploy.yml

kubectl delete deployment web-deploy # to abort

cd aks-learn/Services/

kubectl apply -f svc-lb.yml
```


```bash
helm install my-nginx-ingress oci://ghcr.io/nginxinc/charts/nginx-ingress --version 1.1.0

cd aks-learn/Services/

kubectl apply -f ingress.yml
```

To get username and password for Azure Container Registry - [Click here](https://portal.azure.com/#@ravpawarhotmail.onmicrosoft.com/resource/subscriptions/130ac2c4-7738-417c-ac84-be52935d892f/resourceGroups/rg-aks-learn/providers/Microsoft.ContainerRegistry/registries/ravpawarakslearn/accessKey)
![To get username and password for Azure Container Registry](acr-access-keys.png)




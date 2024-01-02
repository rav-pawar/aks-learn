## In Azure cloud shell 
```powershell
az group create --name rg-aks-learn --location southeastasia
az aks create --resource-group rg-aks-learn --name aks-learn --node-count 3 --enable-addons monitoring --generate-ssh-keys
az aks get-credentials --resource-group rg-aks-learn --name aks-learn
kubectl get nodes
az acr create --resource-group rg-aks-learn --name ravpawarakslearn --sku Basic --admin-enabled true

```

## On machine with docker desktop
```powershell
docker login ravpawarakslearn.azurecr.io # Username: ravpawarakslearn , Password: ?
git clone https://github.com/rav-pawar/aks-learn.git
docker build -t ravpawarakslearn.azurecr.io/aks-learn:v1.0 .
docker push ravpawarakslearn.azurecr.io/aks-learn:v1.0

az acr repository list --name ravpawarakslearn --output table

```

## To get username and password for Azure Container Registry
![To get username and password for Azure Container Registry](acr-access-keys.png)

git clone https://github.com/ddesonier/aks-flux


az login
az account set --subscription 7c27312f-200e-47f6-a855-c308a26f1493

export RESOURCE_GROUP_NAME=gitops-demo-rg
export LOCATION=eastus
export CLUSTER_NAME=GitOpsDemoCluster

az group create -n $RESOURCE_GROUP_NAME -l $LOCATION

az aks create -g $RESOURCE_GROUP_NAME -n $CLUSTER_NAME --enable-managed-identity

az aks get-credentials -g $RESOURCE_GROUP_NAME -n $CLUSTER_NAME

kubectl get nodes

flux check --pre

export GITHUB_TOKEN="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"
export GITHUB_USER="ddesonier"
export GITHUB_REPO="ToB_GitOpsDemo"

flux bootstrap github \
--owner=$GITHUB_USER \
--repository=$GITHUB_REPO \
--branch=main \
--path=./clusters/$CLUSTER_NAME

flux check

git pull

mkdir manifests ; cd manifests

add files

kubectl get kustomization -A
flux reconcile ks flux-system --with-source
kubectl get kustomization -A
git add . ; git commit -m "Added DemoApp" ; git push



✗ Kustomization reconciliation failed: failed to decode Kubernetes YAML from
/tmp/kustomization-3211113944/clusters/GitOpsDemoCluster/demoapp-kustomization.yaml: missing Resource metadata


az aks scale --resource-group $RESOURCE_GROUP_NAME  --name $CLUSTER_NAME --node-count 1 --nodepool-name "nodepool1"

az aks show --resource-group $RESOURCE_GROUP_NAME  --name $CLUSTER_NAME  --query kubernetesVersion --output table


export RG="jcr-services"
export LOCATION="southcentralus"
export SUBID="91a99375-bf02-463a-a775-b923e5851f4b"

# Set subscription scope
az login --identity

az account set --subscription $SUBID

#Create resource group that has multiple tags
az group create -n $RG -l $LOCATION --tags "owner=JCR" "environment=dev" "costcenter=1234" 

#Deploy resources and rollback on error if deployment exists and fails
az deployment group create -n $RG -g $RG -f ./bicep/main.bicep

#show outputs for bicep deployment
az deployment group show -n $RG -g $RG -o json --query properties.outputs.urls.value

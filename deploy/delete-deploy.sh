export RG="jcr-services"


export SUBID="91a99375-bf02-463a-a775-b923e5851f4b"

# Set subscription scope
az login --identity

az account set --subscription $SUBID

az deployment group delete -n $RG -g $RG
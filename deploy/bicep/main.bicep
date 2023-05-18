param location string = resourceGroup().location
param uniqueSeed string = '${subscription().subscriptionId}-${resourceGroup().name}'
param uniqueSuffix string = 'eproducts-${uniqueString(uniqueSeed)}'

param containerAppsEnvironmentName string = 'cae-${uniqueSuffix}'
param logAnalyticsWorkspaceName string = 'log-${uniqueSuffix}'
param appInsightsName string = 'appi-${uniqueSuffix}'

param serviceBusNamespaceName string = 'sb-${uniqueSuffix}'

param cosmosAccountName string = 'cosmos-${uniqueSuffix}'
param cosmosDatabaseName string = 'observations'
param cosmosCollectionName string = 'uploads'
 
param storageAccountName string = 'st${replace(uniqueSuffix, '-', '')}'
param blobContainerName string = 'observations'

module containerAppsEnvModule 'modules/capps-env.bicep' = {
  name: '${deployment().name}--containerAppsEnv'
  params: {
    location: location
    containerAppsEnvName: containerAppsEnvironmentName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    appInsightsName: appInsightsName
  }
}

module serviceBusModule 'modules/servicebus.bicep' = {
  name: '${deployment().name}--servicebus'
  params: {
    serviceBusNamespaceName: serviceBusNamespaceName
    location: location
  }
}

module cosmosModule 'modules/cosmos.bicep' = {
  name: '${deployment().name}--cosmos'
  params: {
    cosmosAccountName: cosmosAccountName
    cosmosDatabaseName: cosmosDatabaseName
    cosmosCollectionName: cosmosCollectionName
    location: location
  }
}

module storageModule 'modules/storage.bicep' = {
  name: '${deployment().name}--storage'
  params: {
    storageAccountName: storageAccountName
    blobContainerName: blobContainerName
    location: location
  }
}

module daprBindingObservationsUpload 'modules/dapr-components/binding-observation-upload.bicep' = {
  name: '${deployment().name}--dapr-binding-receipt'
  params: {
    containerAppsEnvName: containerAppsEnvModule.outputs.name
    storageAccountName: storageModule.outputs.name
  }
}

module daprPubsub 'modules/dapr-components/pubsub.bicep' = {
  name: '${deployment().name}--dapr-pubsub'
  params: {
    containerAppsEnvName: containerAppsEnvModule.outputs.name
    serviceBusNamespaceName: serviceBusModule.outputs.namespaceName
  }
}


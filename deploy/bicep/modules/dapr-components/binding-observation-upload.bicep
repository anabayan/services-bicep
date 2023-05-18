param containerAppsEnvName string
param storageAccountName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

resource cappsEnv 'Microsoft.App/managedEnvironments@2022-10-01' existing = {
  name: containerAppsEnvName
}

resource daprComponent 'Microsoft.App/managedEnvironments/daprComponents@2022-10-01' = {
  name: 'eproducts'
  parent: cappsEnv
  properties: {
    componentType: 'bindings.azure.blobstorage'
    version: 'v1'
    metadata: [
      {
        name: 'storageAccount'
        value: storageAccountName
      }
      {
        name: 'containerName'
        value: 'observationsupload'
      }
      {
        name: 'storageAccessKey'
        secretRef: 'observations-storage-access-key'
      }
      {
        name: 'decodeBase64'
        value: 'true'
      }
    ]
    secrets: [
      {
        name: 'observations-storage-access-key'
        value: storageAccount.listKeys().keys[0].value
      }
    ]
    scopes: [
      'observations-api'
    ]
  }
}

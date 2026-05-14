targetScope = 'resourceGroup'
 
param location string
param storageAccountName string
param vmName string
param adminUsername string
 
@secure()
param adminPassword string
 
module storageModule './modules/storage.bicep' = {
  name: 'storageDeploy'
 
  params: {
    storageAccountName: storageAccountName
    location: location
  }
}
 
module vmModule './modules/vm.bicep' = {
  name: 'vmDeploy'
 
  params: {
    vmName: vmName
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module kvModule './modules/keyvault.bicep' = {
  name: 'kvDeploy'
 
  params: {
    keyVaultName: keyVaultName
    location: location
  }
}

param vmName string
param location string
param adminUsername string
 
@secure()
param adminPassword string
 
// Vnet
resource vnet 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: '${vmName}-vnet'
  location: location
 
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
 
    subnets: [
      {
        name: 'default'
 
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}
 
// Pub ip
resource publicIP 'Microsoft.Network/publicIPAddresses@2023-02-01' = {
  name: '${vmName}-pip'
  location: location
 
  sku: {
    name: 'Standard'
  }
 
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}
 
// Network Interface
resource nic 'Microsoft.Network/networkInterfaces@2023-02-01' = {
  name: '${vmName}-nic'
  location: location
 
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
 
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
 
          privateIPAllocationMethod: 'Dynamic'
 
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
  }
}
 
// Linux VM
resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: vmName
  location: location
 
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
 
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
 
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
 
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
 
      osDisk: {
        createOption: 'FromImage'
      }
    }
 
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

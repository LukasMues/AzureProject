@description('Location for all resources')
param location string = resourceGroup().location

@description('Name of the container group')
param containerGroupName string

@description('Azure Container Registry login server')
param acrLoginServer string

@description('Container image name')
param imageName string

@description('ACR token username')
param tokenUsername string

@description('ACR token password')
param tokenPassword string

@description('Log Analytics Workspace ID')
param logAnalyticsWorkspaceId string

@description('Log Analytics Workspace Key')
param logAnalyticsWorkspaceKey string

@description('Subnet ID for the container group')
param subnetId string = '/subscriptions/91b7fcbc-dfa5-45d6-8418-812ccadfac68/resourceGroups/Project/providers/Microsoft.Network/virtualNetworks/application-vnet/subnets/application32-subnet'

@description('Static private IP address for the container group')
param privateIP string

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: containerGroupName
  location: location
  properties: {
    sku: 'Standard'
    containers: [
      {
        name: containerGroupName
        properties: {
          image: '${acrLoginServer}/${imageName}'
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 2
            }
          }
          ports: [
            {
              port: 80
              protocol: 'tcp'
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    ipAddress: {
      type: 'Private'
      ports: [
        {
          protocol: 'tcp'
          port: 80
        }
      ]
      ip: privateIP
    }
    subnetIds: [
      {
        id: subnetId
      }
    ]
    imageRegistryCredentials: [
      {
        server: acrLoginServer
        username: tokenUsername
        password: tokenPassword
      }
    ]
    diagnostics: {
      logAnalytics: {
        workspaceId: logAnalyticsWorkspaceId
        workspaceKey: logAnalyticsWorkspaceKey
        logType: 'ContainerInsights'
      }
    }
  }
}

output containerGroupId string = containerGroup.id
output containerGroupIP string = containerGroup.properties.ipAddress.ip 

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

@description('Name of the virtual network')
param vnetName string

@description('Static private IP address for the container group')
param privateIP string



module networkModule 'modules/network.bicep' = {
  name: 'networkDeployment'
  params: {
    location: location
    vnetName: vnetName
  }
}

module containerModule 'modules/container.bicep' = {
  name: 'containerDeployment'
  params: {
    location: location
    containerGroupName: containerGroupName
    acrLoginServer: acrLoginServer
    imageName: imageName
    tokenUsername: tokenUsername
    tokenPassword: tokenPassword
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    logAnalyticsWorkspaceKey: logAnalyticsWorkspaceKey
    subnetId: networkModule.outputs.subnetId
    privateIP: privateIP
  }
  dependsOn: [
    networkModule
  ]
}

module appGatewayModule 'modules/appGateway.bicep' = {
  name: 'appGatewayDeployment'
  params: {
    location: location
    subnetId: networkModule.outputs.appGatewaySubnetId
    targetPrivateIp: containerModule.outputs.containerGroupIP
  }
  dependsOn: [
    containerModule
  ]
}

output containerGroupId string = containerModule.outputs.containerGroupId
output containerGroupIP string = containerModule.outputs.containerGroupIP
output appGatewayPublicIp string = appGatewayModule.outputs.appGatewayPublicIp 



param location string = 'eastus'
param aksClusterName string = 'myAKSCluster'
param NodeCount int = 3
param kubernetesVersion string = '1.29.0'
param existingResourceGroupName string = 'Azure_Dev_Practiceteam'
param sshRSAPublicKey string

module vnetModule 'network.bicep' = {
  name: 'vnetDeployment'
  scope: resourceGroup(existingResourceGroupName)
  params: {
    location: location
  }
}

module appGatewayModule 'appgw.bicep' = {
  name: 'appGatewayDeployment'
  scope: resourceGroup(existingResourceGroupName)
  dependsOn: [
    vnetModule
  ]
  params: {
    location: location
    vnetSubnetId: vnetModule.outputs.subnetId
  }
}

// module aksModule 'aks.bicep' = {
//   name: 'aksDeployment'
//   scope: resourceGroup(existingResourceGroupName)
//   dependsOn: [
//     vnetModule, appGatewayModule
//   ]
//   params: {
//     appGatewayId: appGatewayModule.outputs.applicationGatewayId
//     location: location
//     clusterName: aksClusterName
//     aksNodeCount: NodeCount
//     kubernetesVersion: kubernetesVersion
//     vnetSubnetId: vnetModule.outputs.subnetId
//     linuxAdminUsername: 'azureuser'
//     sshRSAPublicKey: sshRSAPublicKey
//   }
// }

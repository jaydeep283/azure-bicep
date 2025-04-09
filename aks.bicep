param clusterName string = 'azbicepaks1'
param location string = 'East US'
param dnsPrefix string = 'azbicep'
param agentVMSize string = 'standard_d2s_v3'
param linuxAdminUsername string
param sshRSAPublicKey string
param vnetSubnetId string
param kubernetesVersion string = '1.29.0'
param appGatewayId string

@minValue(0)
@maxValue(64)
param osDiskSizeGB int = 0

@minValue(1)
@maxValue(5)
param aksNodeCount int = 3

resource aks 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: kubernetesVersion
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: aksNodeCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
        vnetSubnetID: vnetSubnetId
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
  }
}

resource agic 'Microsoft.ContainerService/managedClusters/addons@2024-01-01' = {
  name: 'ingress-appgw'
  parent: aks
  properties: {
    config: {
      appgwId: appGatewayId
    }
  }
}

output controlPlaneFQDN string = aks.properties.fqdn

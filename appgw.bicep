param location string
param vnetSubnetId string

resource publicIP 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: 'azbicepappgwip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource appGw 'Microsoft.Network/applicationGateways@2023-09-01' = {
  name: 'azbicepappgw'
  location: location
  sku: {
    name: 'WAF_v2'
    tier: 'WAF_v2'
  }
  properties: {
    gatewayIPConfigurations: [
      {
        name: 'azbicepappgwipconfig'
        properties: {
          subnet: {
            id: vnetSubnetId
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'azbicepappgwfrontendipconfig'
        properties: {
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
    backendAddressPools: []
    backendHttpSettingsCollection: []
    httpListeners: []
    requestRoutingRules: []
    webApplicationFirewallConfiguration: {
      enabled: true
      firewallMode: 'Prevention'
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.2'
    }
  }
}

output applicationGatewayId string = appGw.id
output applicationGatewayPublicIp string = publicIP.properties.ipAddress

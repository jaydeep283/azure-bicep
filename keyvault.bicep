param location string = 'West India'

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'azbicepkv1'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [] // Add later via RBAC
    enableSoftDelete: true
    enablePurgeProtection: true
  }
}

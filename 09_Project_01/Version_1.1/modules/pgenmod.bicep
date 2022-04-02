param environment string
param location string
param versiontag object = {
  project_version: '1.0'
}

param managedidname string = 'pw-gen_iden_${environment}'
@description('UTC timestamp used to create distinct deployment scripts for each deployment')
param utcValue string = utcNow()

param policyoperation string = 'add'
param objectIDuser string
param tenantsubid string = subscription().tenantId
param vaultname string = 'kvp${environment}-${uniqueString(resourceGroup().id)}'

resource managedgen_sym_link 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedidname
  location: location
  tags: versiontag
}

resource assignrole1 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id, 'assigncontributor')
  properties: {
    principalId: managedgen_sym_link.properties.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  }
}

resource assignrole2 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id, 'assignmanagedoperator')
  properties: {
    principalId: managedgen_sym_link.properties.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f1a07417-d97a-45cb-824c-7a7467783830')
  }
}

resource vault_sym_gen_link 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: vaultname
  tags: versiontag
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantsubid
    accessPolicies: [
      {
        tenantId: tenantsubid
        objectId: objectIDuser
        permissions: {
          keys: [
            'get'
            'list'
            'update'
            'create'
            'import'
            'delete'
            'recover'
            'backup'
            'restore'
            'getrotationpolicy'
            'setrotationpolicy'
            'rotate'
          ]
          secrets: [
            'get'
            'list'
            'set'
            'delete'
            'recover'
            'backup'
            'restore'
          ]
          certificates: [
            'get'
            'list'
            'update'
            'create'
            'import'
            'delete'
            'recover'
            'backup'
            'restore'
            'managecontacts'
            'manageissuers'
            'getissuers'
            'listissuers'
            'setissuers'
            'deleteissuers'
          ]
        }
      }
    ]
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 9
    enableRbacAuthorization: false
    enablePurgeProtection: true
    publicNetworkAccess: 'Enabled'

    networkAcls:{
      defaultAction: 'Allow'
      bypass:'AzureServices'
    }
  }
}

resource accesspsym_link 'Microsoft.KeyVault/vaults/accessPolicies@2021-10-01' = {
  name: policyoperation
  parent: vault_sym_gen_link
  properties: {
    accessPolicies:[
      {
        tenantId: tenantsubid
        objectId: managedgen_sym_link.properties.principalId
        permissions: {
          keys: []
          secrets: [
            'get'
            'list'
            'set'
            'delete'
            'recover'
            'backup'
            'restore'
          ]
          certificates: []
        }
      }
    ]
  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'deployscript-upload-blob-${utcValue}'
  tags: versiontag
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedgen_sym_link.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '7.2.0'
    timeout: 'PT5M'
    retentionInterval: 'PT1H'
    environmentVariables: [
      {
        name: 'vault'
        value: vaultname
      }
    ]
    primaryScriptUri: 'https://raw.githubusercontent.com/techgrounds/cloud-6-repo-MJLippai/main/00_includes/pwgen118.ps1'
  }
  dependsOn:[
    assignrole1
    assignrole2
    vault_sym_gen_link
    accesspsym_link
  ]
}

output kvgen_name string = vault_sym_gen_link.name

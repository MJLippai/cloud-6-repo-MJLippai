// outputs from other modules or main bicep file parameters.
param location string
param environment string
param manindentity string
param kvult string // keyvaulturi
param versiontag object

// filename bootstrap script in storage account.
param filename string = 'serveron.sh'

param store_name string = 'stvm${environment}${uniqueString(resourceGroup().id)}'
param containerName string = 'bootstrap'

@description('UTC timestamp used to create distinct deployment scripts for each deployment')
param utcValue string = utcNow()

// deploymentcript uploads the bootstrap script into the encrypted storage account.
resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'deployscript-upload-blob-${utcValue}'
  tags: versiontag
  location: location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.26.1'
    timeout: 'PT5M'
    retentionInterval: 'PT1H'
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value: store_name
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: store_sym_link.listKeys().keys[0].value
      }
      {
        name: 'CONTENT'
        value: loadFileAsBase64('../bootstrapscript/zscript.sh')
      }
    ]
    
    scriptContent: 'echo $CONTENT | base64 -d > ${filename} && az storage blob upload -f ${filename} -c ${containerName} -n ${filename}'
  }
}

resource store_sym_link 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: store_name
  location: location
  tags: versiontag
  sku: {
    name: 'Standard_RAGRS'
  }
  kind: 'StorageV2'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${manindentity}': {}
      }
    }
  
  properties: {
    defaultToOAuthAuthentication: false
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      identity: {
        userAssignedIdentity: manindentity
      }
      requireInfrastructureEncryption: false
      keyvaultproperties: {
        keyvaulturi: kvult
        keyname: 'encryptkeyall'
      }
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        table: {
          keyType: 'Account'
          enabled: true
        }
        queue: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Keyvault'
    }
    accessTier: 'Hot'
  }
}

resource store_blob_sym_link 'Microsoft.Storage/storageAccounts/blobServices@2021-08-01' = {
  parent: store_sym_link
  name: 'default'
  properties: {
    changeFeed: {
      enabled: false
    }
    restorePolicy: {
      enabled: false
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }

    deleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    isVersioningEnabled: false
  }
}

resource store_container_sym_link 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  parent: store_blob_sym_link
  name: 'bootstrap'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}

output storename_out string = store_sym_link.name
output filename_out string = filename
output containername_out string = store_container_sym_link.name

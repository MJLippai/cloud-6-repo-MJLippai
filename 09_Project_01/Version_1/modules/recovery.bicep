param location string
param environment string
param versiontag object
param vm_web_ID_in string
param vm_web_NAME_in string 
param vm_admin_ID_in string
param vm_admin_NAME_in string

param recovery_vault_name string = 'recovault-${environment}'
param dailybackup_policy string = 'dailypolicy-${environment}'

var pContainer_vmwebserv = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${vm_web_NAME_in}'
var pItem_vmwebserv = 'vm;iaasvmcontainerv2;${resourceGroup().name};${vm_web_NAME_in}'
var pContainer_vmadmin = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${vm_admin_NAME_in}'
var pItem_vmadmin = 'vm;iaasvmcontainerv2;${resourceGroup().name};${vm_admin_NAME_in}'
var backupFabric = 'Azurex'

resource recovery_vault_symlink 'Microsoft.RecoveryServices/vaults@2021-11-01-preview' = {
  name: recovery_vault_name
  location: location
  tags: versiontag
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {}
}


resource recovault_policy_sym_link 'Microsoft.RecoveryServices/vaults/backupPolicies@2021-12-01' = {
  parent: recovery_vault_symlink
  name: dailybackup_policy
  tags: versiontag
  properties: {
    backupManagementType: 'AzureIaasVM'
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '2022-02-22T23:00:00Z'
      ]
      scheduleWeeklyFrequency: 0
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2022-02-22T23:00:00Z'
        ]
        retentionDuration: {
          count: 7
          durationType: 'Days'
        }
      }
    }
    instantRpRetentionRangeInDays: 2
    timeZone: 'W. Europe Standard Time'
  }
}

resource protecteditem_vmserver_sym_link 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2021-12-01' = {
  name: '${recovery_vault_name}/${backupFabric}/${pContainer_vmwebserv}/${pItem_vmwebserv}'
  tags: versiontag
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: recovault_policy_sym_link.id
    sourceResourceId: vm_web_ID_in
  }
} 

resource protecteditem_adminserver_sym_link 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2021-12-01' = {
  name: '${recovery_vault_name}/${backupFabric}/${pContainer_vmadmin}/${pItem_vmadmin}'
  tags: versiontag
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: recovault_policy_sym_link.id
    sourceResourceId: vm_admin_ID_in
  }
} 

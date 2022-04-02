param policyAssignmentName string = 'assign-grouptag-if-missing'
param policyDefinitionID string = '/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070'

param polAssign_vms_tagged_name string = 'backup-vms-withtag'
param policyDefinitionID2 string = '/providers/Microsoft.Authorization/policyDefinitions/345fa903-145c-4fe1-8bcd-93ec2adccde8'

// outputs from other modules or main bicep file parameters.
param environment string = 'test'
param location string = resourceGroup().location

// various parameters named, with specific naming conventations referencing their purpose.

param recovery_vault_name string = 'recovault-${environment}'
param dailybackup_policy string = 'dailypolicy-${environment}'

resource assignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
    name: policyAssignmentName
    scope: resourceGroup()
    location: location
    identity:{
      type: 'SystemAssigned'
    }
    properties: {
        policyDefinitionId: policyDefinitionID
        parameters:{
          tagName:{
            value: 'project'
          }
        }
    }
}
var backup_assign_ObjID = allvmsbackupwithtag.identity.principalId

resource allvmsbackupwithtag 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: polAssign_vms_tagged_name
  scope: resourceGroup()
  location: location
  identity:{
    type: 'SystemAssigned'
  }
  properties: {
      policyDefinitionId: policyDefinitionID2
      parameters:{
        vaultLocation:{
          value: 'westeurope'
        }
        inclusionTagName:{
          value: 'project'
        }
        inclusionTagValue:{
          value: [
            'v1.1'
          ]
        }
        backupPolicyId:{
          value: recovault_policy_sym_link.id
        }
      }
  }
}

resource recovery_vault_symlink 'Microsoft.RecoveryServices/vaults@2021-11-01-preview' = {
  name: recovery_vault_name
  location: location
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {}
}


resource recovault_policy_sym_link 'Microsoft.RecoveryServices/vaults/backupPolicies@2021-12-01' = {
  parent: recovery_vault_symlink
  name: dailybackup_policy
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

resource assignrole1_backup_cont 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id, 'assignbackupcontributor')
  properties: {
    principalId: backup_assign_ObjID
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e467623-bb1f-42f4-a55d-6e525e11384b')
  }
}

resource assignrole2_vm_cont 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id, 'assignvmcontributor')
  properties: {
    principalId: backup_assign_ObjID
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
  }
}

output backup_policy_out string = allvmsbackupwithtag.id

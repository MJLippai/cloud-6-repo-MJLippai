param backup_policyID_in string
param location string

resource remediate_sym_link 'Microsoft.PolicyInsights/remediations@2021-10-01' = {
  name: 'remed_backup_policy'
  properties: {
    failureThreshold: {
      percentage: 1
    }
    filters: {
      locations: [
        location
      ]
    }
    policyAssignmentId: backup_policyID_in
    resourceDiscoveryMode: 'ReEvaluateCompliance'
  }
}

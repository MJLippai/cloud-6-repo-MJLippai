
param environment string = 'test'
param location string
param versiontag object
param objectIDuser string


module pgen 'pgenmod.bicep' = {
  name: 'pgenmod'
  params: {
    objectIDuser: objectIDuser
    location: location
    environment: environment
    versiontag : versiontag
  }
}

module recover 'recov_policy.bicep' = {
  name: 'recovery_module'
  params:{
    environment: environment
    location: location
  }
}

output kvgen_name_out string = pgen.outputs.kvgen_name
output backup_policy_out string = recover.outputs.backup_policy_out

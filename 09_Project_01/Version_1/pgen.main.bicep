targetScope = 'subscription'
param rsg_pgen string = 'pgengroup'
param rsg_pgen_name string = '${rsg_pgen}-${environment}'

param environment string = 'test'
param location string = deployment().location 
param versiontag object = {
  project_version: '1.0'
}

param objectIDuser string


resource rsg_pgen_sym_link 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name : rsg_pgen_name
  location : location
  tags: versiontag
}

module pgen 'modules/pgenmod.bicep' = {
  scope: rsg_pgen_sym_link
  name: 'pgenmod'
  params: {
    objectIDuser: objectIDuser
    location: location
    environment: environment
  }
}

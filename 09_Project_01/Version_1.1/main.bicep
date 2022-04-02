// Resource group must be created on Subcription level. Modules are then deployed with the created resource group as their scope.
targetScope = 'subscription'

param admintrust array // Home/Office IP that will have access to admin server. Current value is for testing, please update. Multiple addresses can be added
param environment string
param versiontag object 
param location string = deployment().location 
param vm_admin_size string = 'Standard_B1s' // Windows admin vm sku
param vm_webserver_size string = 'Standard_B1s' //VMSS sku for linux web server vms
param objectIDuser string //objectID of admin user of Azure portal that should have full access policies to manage Vault resources.
param grp_name string
param projectgrp_name string = '${grp_name}-${environment}' // Name of group to be created and used for deployment, with an environment indicator.

@secure()
param pubkey string // sample test data, to be replaced. SSH public key for VMSS vms.

@secure()
param certpass string


//Group creation. To be used for all resources of this deployment. Version tag assigned to this group is also tag set on all resources missing a tag.
resource project_group_sym_link 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name : projectgrp_name
  location : location
  tags: versiontag
}

//Random password generated for Windows Admin Server, stored in KeyVault. Azure policies are also set for group level. 
module deploy_one './modules/01_first_deploy.bicep' = {
  scope: project_group_sym_link
  name: 'deployment_phase_one'
  params: {
    environment : environment
    location : location
    versiontag : versiontag
    objectIDuser : objectIDuser
  }
}

//Majority of resources. Network modules one and two. Vault and encryption module, following by Storage and Machine Module. Please see Design document for full visual breakdown on deployment order.
module deploy_two './modules/02_second_deploy.bicep' = {
  scope: project_group_sym_link
  name: 'deployment_phase_two'
  params: {
    versiontag: versiontag
    objectIDuser: objectIDuser
    location: location
    environment: environment
    admintrust: admintrust
    vm_admin_size : vm_admin_size
    vm_webserver_size : vm_webserver_size
    pubkey : pubkey
    kvgen_name_in : deploy_one.outputs.kvgen_name_out
    certpass : certpass
  }
}

//Lastly remediation take place to ensure the vms created during deployment are affected by Azure policy backing up all vms (delays in policy taking effect make this a requirement).
module remediate './modules/remediate.bicep' = {
  scope: project_group_sym_link
  name: 'remediate_existing_vms'
  params: {
    backup_policyID_in : deploy_one.outputs.backup_policy_out
    location: location
  }
  dependsOn:[
    deploy_two
  ]
}

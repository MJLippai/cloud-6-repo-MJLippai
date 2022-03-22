param admintrust array
param environment string
param location string
param versiontag object
param vm_admin_size string
param vm_webserver_size string
param objectIDuser string
param kvgen_name_in string

@secure()
param pubkey string

@secure()
param certpass string

//keyvault generated in through first bicep deployment by way of file pgen.main.bicep
resource kv_pass_sym_link 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: kvgen_name_in
}

/* 
Network module includes 2 peered vnets, each with a nsg protected subnet. Nsg rules to allow web traffic to webserver, and only SSH
from admin to webserver through private ips. Also 2 Nics for the two VMs deployed later on.
*/
module networkmod 'network.bicep' = {
  name: 'network_module'
  params:{
    admintrust: admintrust
    versiontag: versiontag
    location: location
    environment: environment
  }
}

module network_2_appgateway 'network_appgw.bicep' = {
  name: 'netmod_2_appgateway'
  params:{
    location: location
    frontend_sub_id_in: networkmod.outputs.front_subnet_out
    versiontag: versiontag
    certpass: certpass
    environment: environment
  }
  dependsOn:[
    networkmod
  ]
}

/* 
Vault module includes vault, key, encryption set and user managed identity which will allow the storage account to be encrypted as well with cmk.
Required accesspolicies are also added to the vault.
*/
module vaultmod 'vault_key.bicep' = {
  name: 'vault_key_module'
  params:{
    versiontag: versiontag
    location: location
    environment: environment
    objectIDuser: objectIDuser
  }
}


/*
Storage account is created and a deployment script is used to upload the bootstrap script to an encrypted storage account.
Storage account makes use of user managed identity (and vault) to allow encryption through cmk.
*/
module storeboot 'storeboot.bicep' = {
  name: 'storeboot_module'
  params:{
    environment: environment
    location: location
    versiontag: versiontag
    kvult: vaultmod.outputs.kvurl_out
    manindentity: vaultmod.outputs.manidentityID_out
  }
}

/*
Linux web server and windows admin server are deployed in the machines module, making use of resources deployed from above listed
modules.
*/
module machines 'machines.bicep' = {
  name: 'machine_module'
  params:{
    environment: environment
    versiontag: versiontag
    location: location
    pubkey: pubkey
    passadmin: kv_pass_sym_link.getSecret('ExamplePassword15')
    vm_admin_size: vm_admin_size
    vm_webserver_size: vm_webserver_size
    diskencryptId: vaultmod.outputs.diskencrypt_IDout
    nic_id_admin: networkmod.outputs.nic_admin_out
    backend_sub_in: networkmod.outputs.backend_subnet_out
    backendpool_id_in: network_2_appgateway.outputs.backendpool_out
    admin_ip_in: networkmod.outputs.admin_ip_out
  }
  dependsOn:[
    networkmod
    network_2_appgateway
  ]
}


// Resource group must be created on Subcription level. Modules are then deployed with the created resource group as their scope.
targetScope = 'subscription'
param rsgname string = 'rsgprojectv1.0test'

// Home/Office IP that will have access to admin server. Current value was for testing, please update. If multiple IPs need to be giving access, please simply add a list to this array.
param admintrust array

// Sample key data, please adjust the urls to point to a new location or simply provide the data as a string.
param pubkey string = loadTextContent('./TestKeys/linwebkey.pub') // sample test data

//param passadmin string = loadTextContent('./TestKeys/linwebkey.pub') // sample test data

param environment string = 'test'
param location string = deployment().location 
param versiontag object = {
  project_version: '1.0'
}
param vm_admin_size string = 'Standard_B1s'
param vm_webserver_size string = 'Standard_B1s'

//objectID of admin user of Azure portal that should have full access policies to manage Vault resources.
param objectIDuser string
param kvg_name string

resource resourcegproject 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name : rsgname
  location : location
  tags: versiontag
}

//keyvault generated in through first bicep deployment by way of file pgen.main.bicep
resource kv_pass_sym_link 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: kvg_name
  scope: resourceGroup('pgengroup115-test')
}

/* 
Network module includes 2 peered vnets, each with a nsg protected subnet. Nsg rules to allow web traffic to webserver, and only SSH
from admin to webserver through private ips. Also 2 Nics for the two VMs deployed later on.
*/
module networkmod 'modules/network.bicep' = {
  name: 'network_module'
  scope: resourcegproject
  params:{
    admintrust: admintrust
    versiontag: versiontag
    location: location
    environment: environment
  }
}

/* 
Vault module includes vault, key, encryption set and user managed identity which will allow the storage account to be encrypted as well with cmk.
Required accesspolicies are also added to the vault.
*/
module vaultmod 'modules/vault_key.bicep' = {
  name: 'vault_key_module'
  scope: resourcegproject
  params:{
    versiontag: versiontag
    location: location
    environment: environment
    objectIDuser: objectIDuser
  }
}

/* 
Linux web server and windows admin server are deployed in the machines module, making use of resources deployed from above listed
modules.
*/
module machines 'modules/machines.bicep' = {
  name: 'machine_module'
  scope: resourcegproject
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
    nic_id_webserver: networkmod.outputs.nic_webserver_out
  }
}

/* 
Storage account is created and a deployment script is used to upload the bootstrap script to an encrypted storage account.
Storage account makes use of user managed identity (and vault) to allow encryption through cmk.
*/
module storeboot 'modules/storeboot.bicep' = {
  name: 'storeboot_module'
  scope: resourcegproject
  params:{
    environment: environment
    location: location
    versiontag: versiontag
    kvult: vaultmod.outputs.kvurl_out
    manindentity: vaultmod.outputs.manidentityID_out
  }
}
/*
Recovery vault is created, a specific backup policy is set up and backup items are created with said backup policy.

module recover 'modules/recovery.bicep' = {
  name: 'recovery_module'
  scope: resourcegproject
  params:{
    environment: environment
    location: location
    versiontag: versiontag
    vm_web_ID_in:  machines.outputs.vm_web_ID_out
    vm_web_NAME_in: machines.outputs.vm_web_NAME_out
    vm_admin_ID_in:  machines.outputs.vm_admin_ID_out
    vm_admin_NAME_in: machines.outputs.vm_admin_NAME_out
  }
}
*/

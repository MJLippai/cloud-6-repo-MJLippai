
// outputs from other modules or main bicep file parameters.
param environment string 
param location string
param diskencryptId string
param nic_id_admin string
param nic_id_webserver string
param versiontag object

param vm_admin_size string = 'Standard_B1s'
param vm_webserver_size string = 'Standard_B1s'

param vm_lin_webserv_name string = 'vm-webserv-${environment}'
param vm_win_admin_name string = 'vm-admin${environment}'

// Sample key data, please adjust the urls to point to a new location or simply provide the data as a string.
param pubkey string

@secure()
param passadmin string



// sample boostrap script loaded as base64 encoding. Adjust corresponding script to adjust Userdata or provide new path.
var script64 = loadFileAsBase64('../bootstrapscript/zscript.sh') 

resource vm_lin_webserv_sym_link 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vm_lin_webserv_name
  location: location
  tags: versiontag
  zones: [
    '2'
  ]
  properties: {

    hardwareProfile: {
      vmSize: vm_webserver_size
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-impish'
        sku: '21_10-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          diskEncryptionSet: {
            id: diskencryptId
          }
          storageAccountType: 'StandardSSD_LRS'
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
    }
    osProfile: {
      customData: script64
      computerName: vm_lin_webserv_name
      adminUsername: '${vm_lin_webserv_name}user'
      adminPassword: null
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              keyData: pubkey
              path: '/home/${vm_lin_webserv_name}user/.ssh/authorized_keys'
            }
          ]
        }
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true

    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic_id_webserver
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource vm_win_admin_sym_link 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vm_win_admin_name
  location: location
  tags: versiontag
  zones: [
    '1'
  ]
  properties: {
    hardwareProfile: {
      vmSize: vm_admin_size
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          diskEncryptionSet: {
            id: diskencryptId
          }
          storageAccountType: 'StandardSSD_LRS'
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
    }
    osProfile: {
      computerName: vm_win_admin_name
      adminUsername: '${vm_win_admin_name}user'
      adminPassword: passadmin
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
      }
      secrets: []
      allowExtensionOperations: true

    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic_id_admin
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}
output vm_web_ID_out string = vm_lin_webserv_sym_link.id
output vm_web_NAME_out string = vm_lin_webserv_sym_link.name

output vm_admin_ID_out string = vm_win_admin_sym_link.id
output vm_admin_NAME_out string = vm_win_admin_sym_link.name


// outputs from other modules or main bicep file parameters.
param environment string = 'test'
param location string 
param diskencryptId string
param nic_id_admin string
param versiontag object
param admin_ip_in string

param vm_admin_size string = 'Standard_B1s'
param vm_webserver_size string = 'Standard_B1s'

param vmss_lin_webserv_name string = 'vmss-webserv-${environment}'
param vm_win_admin_name string = 'vm-admin${environment}'

param networkSecurityGroups_basicNsgvnet_webserver_test_nic01_name string = 'basicNsgvnet_webserver_test-nic01'

// Sample key data, please adjust the urls to point to a new location or simply provide the data as a string.
param pubkey string

@secure()
param passadmin string

param backend_sub_in string
param backendpool_id_in string

// sample boostrap script loaded as base64 encoding. Adjust corresponding script to adjust Userdata or provide new path.
var script64 = loadFileAsBase64('../bootstrapscript/zscript.sh') 


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

output vm_admin_ID_out string = vm_win_admin_sym_link.id
output vm_admin_NAME_out string = vm_win_admin_sym_link.name


resource vmss_lin_webserv_sym_link 'Microsoft.Compute/virtualMachineScaleSets@2021-11-01' = {
  name: vmss_lin_webserv_name
  location: location
  tags: versiontag
  zones: [
    '2'
  ]
  sku: {
    name: vm_webserver_size
    
    tier: 'Standard'
    capacity: 1
  }

  properties: {
    singlePlacementGroup: false
    orchestrationMode: 'Flexible'
    virtualMachineProfile: {
      osProfile: {
        customData: script64
        computerNamePrefix: 'myvms7d1f'
        adminUsername: '${vmss_lin_webserv_name}user'
        adminPassword: null
        linuxConfiguration: {
          ssh: {
            publicKeys: [
              {
                keyData: pubkey
                path: '/home/${vmss_lin_webserv_name}user/.ssh/authorized_keys'
              }
            ]
          }
          disablePasswordAuthentication: true
          provisionVMAgent: true
          patchSettings: {
            patchMode: 'ImageDefault'
            assessmentMode: 'ImageDefault'
          }
        }
        secrets: []
        allowExtensionOperations: true
      }
      storageProfile: {
        osDisk: {
          osType: 'Linux'
          createOption: 'FromImage'
          caching: 'ReadWrite'
          managedDisk: {
            storageAccountType: 'Standard_LRS'
            diskEncryptionSet: {
              id: diskencryptId
            }
          }
          diskSizeGB: 30
        }
        imageReference: {
          publisher: 'Canonical'
          offer: 'UbuntuServer'
          sku: '18.04-LTS'
          version: 'latest'
        }
      }
      extensionProfile: {
        extensions: [
          {
            name: 'HealthExtension'
            properties: {
              autoUpgradeMinorVersion: false
              publisher: 'Microsoft.ManagedServices'
              type: 'ApplicationHealthLinux'
              typeHandlerVersion: '1.0'
              settings: {
                protocol: 'http'
                port: 80
                requestPath: '/'
              }
            }
          }
        ]
      }
      networkProfile: {
        networkApiVersion:'2020-11-01'
        networkInterfaceConfigurations: [
          {
            name: 'myvms7d1fNic'
            properties: {
              primary: true
              enableAcceleratedNetworking: false
              enableIPForwarding: false
              ipConfigurations: [
                {
                  name: 'myvms7d1fIPConfig'
                  properties: {
                    subnet: {
                      id: backend_sub_in
                    }
                    privateIPAddressVersion: 'IPv4'
                    applicationGatewayBackendAddressPools: [
                      {
                        id: backendpool_id_in
                      }
                    ]
                  }
                }
              ]
              networkSecurityGroup: {
                id: networkSecurityGroups_basicNsgvnet_webserver_test_nic01_name_resource.id
              }
            }
          }
        ]
      }
    }
    platformFaultDomainCount: 1
    automaticRepairsPolicy: {
      enabled: true
      gracePeriod: 'PT30M'
    }
  }
}

resource networkSecurityGroups_basicNsgvnet_webserver_test_nic01_name_resource 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: networkSecurityGroups_basicNsgvnet_webserver_test_nic01_name
  location: location
  tags: {
    project: 'v1.1'
  }
  properties: {
    securityRules: []
  }
}

resource networkSecurityGroups_basicNsgvnet_webserver_test_nic01_rules_resource 'Microsoft.Network/networkSecurityGroups/securityRules@2021-05-01' = {
  parent: networkSecurityGroups_basicNsgvnet_webserver_test_nic01_name_resource
  name: 'nsg_webrules_SSH_nic'
  properties: {
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: admin_ip_in
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 140
    direction: 'Inbound'
  }
}


resource autoscalesettings_vm_symlink 'microsoft.insights/autoscalesettings@2021-05-01-preview' = {
  name: 'autoscalesettings_vmss2121autoscale'
  location: location
  properties: {
    profiles: [
      {
        name: 'Profile1'
        capacity: {
          minimum: '1'
          maximum: '3'
          default: '1'
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'Percentage CPU'
              metricResourceUri: vmss_lin_webserv_sym_link.id
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT10M'
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: 75
              dividePerInstance: false
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT1M'
            }
          }
          {
            metricTrigger: {
              metricName: 'Percentage CPU'
              metricResourceUri: vmss_lin_webserv_sym_link.id
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'LessThan'
              threshold: 25
              dividePerInstance: false
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT1M'
            }
          }
        ]
      }
    ]
    enabled: true
    targetResourceUri: vmss_lin_webserv_sym_link.id
  }
}

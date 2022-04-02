param environment string
param location string
param admintrust array

param vnet_webserver_name string = 'vnet_webserver_${environment}'
param vnet_admin_name string = 'vnet_admin_${environment}'
param pubip_winadmin_name string = 'winadmin_ip_${environment}'
param nic_winadmin_name string = 'winadmin_nic_${environment}'
param pubip_linwebser_name string = 'linwebserverb_ip_${environment}'
param nsg_admin_name string = 'admin_serv_nsg_${environment}'
param nsg_web_name string = 'web_server_nsg_${environment}'
param nic_weblinserv_name string = 'linwebserver_nic_${environment}'

param nsg_webrules_SSH_name string = 'nsg_webrules_SHH_${environment}'

param versiontag object

// nsgroups and rules follow:
resource nsg_admin_sym_link 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: nsg_admin_name
  location: location
  tags: versiontag
  properties: {
    securityRules: [
      {
        name: 'admin_trust'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: admintrust
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource nsg_web_sym_link 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: nsg_web_name
  location: location
  tags: versiontag
  properties: {
    securityRules: [
      {
        name: 'https_in_webnsg'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'http_in_webnsg'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}
resource nsg_webrules_SSH_sym_link 'Microsoft.Network/networkSecurityGroups/securityRules@2021-05-01' = {
  parent: nsg_web_sym_link
  name: nsg_webrules_SSH_name
  properties: {
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: nic_winadmin_sym_link.properties.ipConfigurations[0].properties.privateIPAddress
    destinationAddressPrefix: nic_weblinserv_sym_link.properties.ipConfigurations[0].properties.privateIPAddress
    access: 'Allow'
    priority: 140
    direction: 'Inbound'
  }
}

resource pubip_linwebser_sym_link 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: pubip_linwebser_name
  location: location
  tags: versiontag
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
  ]
  properties:{
    publicIPAllocationMethod:'Static'
  }
}

resource pubip_winadmin_sym_link 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: pubip_winadmin_name
  location: location
  tags: versiontag
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
  ]
  properties:{
    publicIPAllocationMethod:'Static'
  }
}

resource nic_weblinserv_sym_link 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: nic_weblinserv_name
  location: location
  tags: versiontag
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.20.20.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pubip_linwebser_sym_link.id
          }
          subnet: {
            id: vnet_webserver_subnet_sym_link.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource nic_winadmin_sym_link 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: nic_winadmin_name
  location: location
  tags: versiontag
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.10.10.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pubip_winadmin_sym_link.id
          }
          subnet: {
            id: vnet_admin_subnet_sym_link.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource vnet_admin_sym_link 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: vnet_admin_name
  location: location
  tags: versiontag
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.10.0/24'
      ]
    }
    enableDdosProtection: false
  }
}

resource vnet_admin2serv_sym_link 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnet_admin_sym_link
  name: '${vnet_admin_name}-${vnet_webserver_name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet_webserv_sym_link.id
    }
  }
  dependsOn: [
    vnet_admin_subnet_sym_link
    vnet_webserver_subnet_sym_link
  ]
}

resource vnet_webserv_sym_link 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: vnet_webserver_name
  location: location
  tags: versiontag
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.20.0/24'
      ]
    }
    enableDdosProtection: false
  }
}

resource vnet_webserv2admin_sym_link 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnet_webserv_sym_link
  name: '${vnet_webserver_name}-${vnet_admin_name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet_admin_sym_link.id
    }
  }
  dependsOn: [
    vnet_admin_subnet_sym_link
    vnet_webserver_subnet_sym_link
  ]
}

resource vnet_admin_subnet_sym_link'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${vnet_admin_name}/admin_subnet'
  properties: {
    addressPrefix: '10.10.10.0/26'
    networkSecurityGroup: {
      id: nsg_admin_sym_link.id
    }
    serviceEndpoints: [
      {
        service: 'Microsoft.KeyVault'
        locations: [
          '*'
        ]
      }
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    vnet_admin_sym_link
  ]
}

resource vnet_webserver_subnet_sym_link 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${vnet_webserver_name}/webserv_subnet'
  properties: {
    addressPrefix: '10.20.20.0/25'
    networkSecurityGroup: {
      id: nsg_web_sym_link.id
    }
    serviceEndpoints: [
      {
        service: 'Microsoft.KeyVault'
        locations: [
          '*'
        ]
      }
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    vnet_webserv_sym_link
  ]
}
output nic_admin_out string = nic_winadmin_sym_link.id
output nic_webserver_out string = nic_weblinserv_sym_link.id

param environment string
param location string
param admintrust array
param versiontag object
param natGateways_nat_serv_outbound_name string = 'nat_serv_outbound'
param vnet_webserver_name string = 'vnet_webserver_${environment}'
param vnet_admin_name string = 'vnet_admin_${environment}'
param pubip_winadmin_name string = 'winadmin_ip_${environment}'
param nic_winadmin_name string = 'winadmin_nic_${environment}'

param nsg_admin_name string = 'admin_serv_nsg_${environment}'
param nsg_web_name string = 'web_server_nsg_${environment}'

param nsg_webrules_SSH_name string = 'nsg_webrules_SHH_${environment}'


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
      {
        name: 'Port_gw'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '65200-65535'
          sourceAddressPrefix: 'GatewayManager'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 150
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'Port_azlb'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 160
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
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 140
    direction: 'Inbound'
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

resource pub_out_sym_link 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: 'outip'
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

resource nic_winadmin_sym_link 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: nic_winadmin_name
  location: location
  tags: versiontag
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {

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
    enableIPForwarding: true
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

resource vnet_admin_subnet_sym_link 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name:'admin_subnet'
  parent: vnet_admin_sym_link
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
  dependsOn:[
    vnet_admin_subnet_sym_link
    virtualNetworks_myVNet_name_myAGSubnet
    virtualNetworks_myVNet_name_myBackendSubnet
  ]
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
  dependsOn:[
    vnet_admin_subnet_sym_link
    virtualNetworks_myVNet_name_myAGSubnet
    virtualNetworks_myVNet_name_myBackendSubnet
  ]
}


resource vnet_webserv_sym_link 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: vnet_webserver_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.20.0/24'
      ]
    }
    enableDdosProtection: false
  }
}


resource virtualNetworks_myVNet_name_myAGSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: vnet_webserv_sym_link
  name: 'myAGSubnet'
  properties: {
    addressPrefix: '10.20.20.0/25'
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    networkSecurityGroup:{
      id: nsg_web_sym_link.id
    }
  }
}

resource virtualNetworks_myVNet_name_myBackendSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: vnet_webserv_sym_link
  name: 'myBackendSubnet'
  properties: {
    natGateway: {
      id: natGateways_nat_serv_outbound_name_resource.id
    }
    addressPrefix: '10.20.20.128/25'
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource natGateways_nat_serv_outbound_name_resource 'Microsoft.Network/natGateways@2020-11-01' = {
  name: natGateways_nat_serv_outbound_name
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    idleTimeoutInMinutes: 4
    publicIpAddresses: [
      {
        id: pub_out_sym_link.id
      }
    ]
  }
}

output backend_subnet_out string = virtualNetworks_myVNet_name_myBackendSubnet.id
output front_subnet_out string = virtualNetworks_myVNet_name_myAGSubnet.id
output nic_admin_out string = nic_winadmin_sym_link.id
output admin_ip_out string = nic_winadmin_sym_link.properties.ipConfigurations[0].properties.privateIPAddress

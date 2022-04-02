param applicationGateways_myAppGateway_name string = 'myAppGateway-${environment}'
param publicIPAddresses_myAGPublicIPAddress_name string = 'myAGPublicIPAddress-${environment}'

param location string 
param versiontag object 
param frontend_sub_id_in string
param environment string

@secure()
param certpass string


resource frontag_ip_sym_link 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIPAddresses_myAGPublicIPAddress_name
  tags: versiontag
  location: location
  zones: [
    '1'
  ]
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource applicationGateways_myAppGateway_name_resource 'Microsoft.Network/applicationGateways@2020-11-01' = {
  name: applicationGateways_myAppGateway_name
  location: location
  tags: versiontag
  zones: [
    '1'
  ]
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
      capacity: 2
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayFrontendIP'
        properties: {
          subnet: {
            id: frontend_sub_id_in
          }
        }
      }
    ]
    sslCertificates: [
      {
        name: '${applicationGateways_myAppGateway_name}SslCert'
        properties: {
          data: loadFileAsBase64('../appgwcert.pfx')
          password: certpass
        }
      }
    ]
    authenticationCertificates: []
    frontendIPConfigurations: [
      {
        name: 'appGatewayFrontendIP'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: frontag_ip_sym_link.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'appGatewayFrontendPort'
        properties: {
          port: 443
        }
      }
      {
        name: 'httpPort'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'appGatewayBackendPool'
        properties: {
          backendAddresses: []
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'appGatewayBackendHttpSettings'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          connectionDraining: {
            enabled: false
            drainTimeoutInSec: 1
          }
          pickHostNameFromBackendAddress: false
          requestTimeout: 30
        }
      }
    ]
    httpListeners: [
      {
        name: 'appGatewayHttpListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations/', applicationGateways_myAppGateway_name, 'appGatewayFrontendIP')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts/', applicationGateways_myAppGateway_name, 'appGatewayFrontendPort')
          }
          protocol: 'Https'
          sslCertificate: {
            id: resourceId('Microsoft.Network/applicationGateways/sslCertificates/', applicationGateways_myAppGateway_name, '${applicationGateways_myAppGateway_name}SslCert')
          }
          hostNames: []
          requireServerNameIndication: false
        }
      }
      {
        name: 'myListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations/', applicationGateways_myAppGateway_name, 'appGatewayFrontendIP')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts/', applicationGateways_myAppGateway_name, 'httpPort')
          }
          protocol: 'Http'
          hostNames: []
          requireServerNameIndication: false
        }
      }
    ]
    urlPathMaps: []
    requestRoutingRules: [
      {
        name: 'rule1'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners/', applicationGateways_myAppGateway_name, 'appGatewayHttpListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools/', applicationGateways_myAppGateway_name, 'appGatewayBackendPool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection/', applicationGateways_myAppGateway_name, 'appGatewayBackendHttpSettings')
          }
        }
      }
      {
        name: 'rule2'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners/', applicationGateways_myAppGateway_name, 'myListener')
          }
          redirectConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/redirectConfigurations/', applicationGateways_myAppGateway_name, 'httpToHttps')
          }
        }
      }
    ]
    probes: []
    rewriteRuleSets: []
    redirectConfigurations: [
      {
        name: 'httpToHttps'
        properties: {
          redirectType: 'Permanent'
          targetListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners/', applicationGateways_myAppGateway_name, 'appGatewayHttpListener')
          }
          includePath: true
          includeQueryString: true
          requestRoutingRules: [
            {
              id: resourceId('Microsoft.Network/applicationGateways/requestRoutingRules/', applicationGateways_myAppGateway_name, 'rule2')
            }
          ]
        }
      }
    ]
  }
}


output backendpool_out string = applicationGateways_myAppGateway_name_resource.properties.backendAddressPools[0].id

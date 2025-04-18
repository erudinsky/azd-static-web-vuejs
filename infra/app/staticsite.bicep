metadata description = 'Creates an Azure Static Web Apps instance.'
param name string
param location string = resourceGroup().location
param tags object = {}

param sku object = {
  name: 'Free'
  tier: 'Free'
}

resource web 'Microsoft.Web/staticSites@2024-04-01' = {
  name: name
  location: location
  tags: tags
  sku: sku
  properties: {
     allowConfigFileUpdates: true
     buildProperties: {
       appArtifactLocation: 'dist'
       appLocation: '/'
     }
  }
}

output uri string = 'https://${web.properties.defaultHostname}'

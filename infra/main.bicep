targetScope = 'subscription'

@minLength(1)
@maxLength(20)
@description('Name of the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@description('Name of the resource group to deploy the static web app to. If not provided, a new resource group will be created.')
@maxLength(90)
@minLength(1)
param resourceGroupName string

@description('Name of the static web app.')
@maxLength(60)
@minLength(2)
param staticSiteName string
@description('Location of the resource group.')
param location string

var abbrs = loadJsonContent('./abbreviations.json')
var tags = { 'azd-env-name': environmentName }

resource rg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.resourcesResourceGroups}${environmentName}'
  location: location
  tags: tags
}

module web './app/staticsite.bicep' = {
  scope: rg
  name: staticSiteName
  params: {
    name: staticSiteName
    location: rg.location
    tags: tags
  }
}

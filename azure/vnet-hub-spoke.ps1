# Bash syntax: Cloud Shell (Bash) or Git Bash

# create resource group
az group create --name test-rg --location westeurope

# create hub and spoke VNets
az network vnet create --name hub --resource-group test-rg --address-prefixes 10.0.0.0/16
az network vnet create --name spoke --resource-group test-rg --address-prefixes 10.1.0.0/16

# create peering between hub and spoke
az network vnet peering create --name hub-to-spoke --resource-group test-rg \
  --vnet-name hub --remote-vnet spoke --allow-vnet-access
az network vnet peering create --name spoke-to-hub --resource-group test-rg \
  --vnet-name spoke --remote-vnet hub --allow-vnet-access

# Prediction (a)
az network vnet peering update --name spoke-to-hub --resource-group test-rg \
  --vnet-name spoke --set useRemoteGateways=true

# error
(RemoteVnetHasNoGateways) Peering /subscriptions/ebd1a49a-1bed-4c35-abff-65bfed1a4633/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/spoke/virtualNetworkPeerings/spoke-to-hub cannot have UseRemoteGateway flag set to true because remote virtual network /subscriptions/ebd1a49a-1bed-4c35-abff-65bfed1a4633/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/hub referenced by the peering does not have any gateways.
Code: RemoteVnetHasNoGateways
Message: Peering /subscriptions/ebd1a49a-1bed-4c35-abff-65bfed1a4633/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/spoke/virtualNetworkPeerings/spoke-to-hub cannot have UseRemoteGateway flag set to true because remote virtual network /subscriptions/ebd1a49a-1bed-4c35-abff-65bfed1a4633/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/hub referenced by the peering does not have any gateways.

# Prediction (b)
az network vnet peering update --name hub-to-spoke --resource-group test-rg \
  --vnet-name hub --set allowGatewayTransit=true

# allowed 

# Clean up
az group delete --name test-rg --yes --no-wait
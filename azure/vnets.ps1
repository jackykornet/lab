# Bash syntax: run in Cloud Shell (Bash) or Git Bash, not in PowerShell
az group create --name test-rg --location eastus2

az network vnet create --name vnet-1 --resource-group test-rg --address-prefixes 10.0.0.0/16 --subnet-name subnet-1 --subnet-prefix 10.0.0.0/24
az network vnet create --name vnet-2 --resource-group test-rg --address-prefixes 10.1.0.0/16 --subnet-name subnet-1 --subnet-prefix 10.1.0.0/24

$vNet1Id=$(az network vnet show --resource-group test-rg --name vnet-1 --query id --out tsv)
$vNet2Id=$(az network vnet show --resource-group test-rg --name vnet-2 --query id --out tsv)

# First side only, then check prediction (a)
az network vnet peering create --name vnet-1-to-vnet-2 --resource-group test-rg --vnet-name vnet-1 --remote-vnet $vNet2Id --allow-vnet-access
az network vnet peering show --name vnet-1-to-vnet-2 --resource-group test-rg --vnet-name vnet-1 --query peeringState

# Second side, then check again
az network vnet peering create --name vnet-2-to-vnet-1 --resource-group test-rg --vnet-name vnet-2 --remote-vnet $vNet1Id --allow-vnet-access
az network vnet peering show --name vnet-1-to-vnet-2 --resource-group test-rg --vnet-name vnet-1 --query peeringState

# Prediction (b): an overlapping VNet
az network vnet create --name vnet-3 --resource-group test-rg --address-prefixes 10.0.0.0/24
vNet3Id=$(az network vnet show --resource-group test-rg --name vnet-3 --query id --out tsv)
az network vnet peering create --name vnet-1-to-vnet-3 --resource-group test-rg --vnet-name vnet-1 --remote-vnet $vNet3Id --allow-vnet-access

# Clean up
az group delete --name test-rg --yes --no-wait
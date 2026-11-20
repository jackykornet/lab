cd 01-basis

# eenmalig: providers downloaden
terraform init

# code netjes opmaken (optioneel)
terraform fmt

# syntax controleren
terraform validate

# plan maken en opslaan in ./tfplan
terraform plan -out=tfplan

# lees de uitvoer: "Plan: 1 to add, 0 to change, 0 to destroy."

# dit plan uitvoeren
terraform apply tfplan

#
# with a tfvars file you can specify variable values for the plan and apply commands. This is useful for managing different environments (e.g., dev, prod) with different configurations.
terraform plan -var-file=dev.tfvars  -out=tfplan

# apply the plan with the specified variable values
terraform apply -var-file=dev.tfvars

# Create a resource group and storage account for storing the Terraform state file in Azure. This is necessary for remote state management, which allows multiple team members to work on the same infrastructure without conflicts.
az group create -n rg-tfstate-weu -l westeurope

# create the storage account and container for storing the Terraform state file in Azure. This is necessary for remote state management, which allows multiple team members to work on the same infrastructure without conflicts.
az storage account create -n sttfstate0002 -g rg-tfstate-weu --sku Standard_LRS --allow-blob-public-access false

# create a container in the storage account for storing the Terraform state file in Azure. This is necessary for remote state management, which allows multiple team members to work on the same infrastructure without conflicts.
az storage container create -n tfstate --account-name sttfstate0002 --auth-mode login

# give rights to the signed-in user to access the storage account and container for storing the Terraform state file in Azure. This is necessary for remote state management, which allows multiple team members to work on the same infrastructure without conflicts.
az role assignment create --role "Storage Blob Data Contributor" --assignee $(az ad signed-in-user show --query id -o tsv) --scope $(az storage account show -n sttfstate0002 --query id -o tsv)

# writes state to the backend defined in backend.tf
terraform init -migrate-state


# refresh the list of subscriptions and display them in a table format
# needed when create new subscriptions in the Azure portal and you want to see them in the CLI
# otherwise you get an error like: "The subscription 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' could not be found."
az account list --refresh -o table

# check which subscription is currently listed in the CLI
az account list

# logout and login again to refresh the list of subscriptions and display them in a table format
az logout
az login

# run the following command to create a plan for the Terraform configuration using the variable values specified in the dev.tfvars file. The plan will be saved to a file named tfplan, which can be applied later to create or modify resources in Azure.
terraform plan -var-file=dev.tfvars -out=tfplan

# check the plan to see what changes will be made to the infrastructure. The output will show a summary of the changes, including the number of resources that will be added, changed, or destroyed.
# run the following command to apply the plan saved in the tfplan file. This will create or modify resources in Azure based on the changes specified in the plan.
terraform apply -var-file=dev.tfvars tfplan

# run the following command to show the details of the plan saved in the tfplan file. This will display a summary of the changes that will be made to the infrastructure, including the resources that will be added, changed, or destroyed.
terraform show tfplan

# new subscriptions need to register providers. For network these providers are needed: Microsoft.Network, Microsoft.OperationalInsights, Microsoft.Insights
SUB=14881b9e-890a-4229-8147-cf9fe3233781
az provider register --namespace Microsoft.Network --subscription $SUB
az provider register --namespace Microsoft.OperationalInsights --subscription $SUB
# for Microsoft.Insights you need to register the provider in the subscription where you want to create the log analytics workspace. In this lab we create the log analytics workspace in the platform subscription, so we need to register the provider in that subscription.
az provider register --namespace Microsoft.Insights --subscription $SUB

# check the registration status. Should be "Registered" for all three providers.
az provider show --namespace Microsoft.Network --subscription $SUB --query registrationState -o tsv
az provider show --namespace Microsoft.OperationalInsights --subscription $SUB --query registrationState -o tsv
az provider show --namespace Microsoft.Insights --subscription $SUB --query registrationState -o tsv

# after a failed apply the plan is not usable anymore and you need to create a new plan. You can do this by running the following command:
terraform plan -var-file=dev.tfvars -out=tfplan



# to import existing resources into Terraform state, you can use the terraform import command. This command allows you to bring existing resources under Terraform management without recreating them. The syntax for the command is as follows:

# create a import.tf file with the following content. This file will be used to import the existing resources into Terraform state. The import.tf file should contain the following code:
import {
  to = azurerm_management_group.platform
  id = "/providers/Microsoft.Management/managementGroups/tenrok-platform"
}

# run the plan command to create a plan for the Terraform configuration using the variable values specified in the dev.tfvars file. The plan will be saved to a file named tfplan, which can be applied later to create or modify resources in Azure.
terraform plan -var-file=dev.tfvars -out=tfplan
# Plan: 1 to import, 3 to add, 1 to change, 0 to destroy.
# run the apply command to apply the plan saved in the tfplan file. This will import the existing resources into Terraform state and create or modify resources in Azure based on the changes specified in the plan.
terraform apply -var-file=dev.tfvars tfplan
# you can remove the import.tf file after the import is complete, as it is no longer needed. The imported resources will now be managed by Terraform and can be modified or destroyed using Terraform commands.

# test policies

# check location (should fail because the location is not allowed by the policy)
az group create -n rg-policytest -l eastus --tags owner=jacky --subscription ebd1a49a-1bed-4c35-abff-65bfed1a4633

# check tags (should fail because the tags are not allowed by the policy)
az group create -n rg-policytest -l westeurope --subscription ebd1a49a-1bed-4c35-abff-65bfed1a4633

# check tags and location (should succeed because the tags and location are allowed by the policy)
az group create -n rg-policytest -l westeurope --tags owner=jacky --subscription ebd1a49a-1bed-4c35-abff-65bfed1a4633

# in sandbox (niet onder Landing zones): alleen de locatie-policy geldt
az group create -n rg-policytest -l westeurope --subscription 7d41f96e-10e3-4840-86f2-a3014b77e98c

# cleanup
az group delete -n rg-policytest --yes --subscription ebd1a49a-1bed-4c35-abff-65bfed1a4633
az group delete -n rg-policytest --yes --subscription 7d41f96e-10e3-4840-86f2-a3014b77e98c
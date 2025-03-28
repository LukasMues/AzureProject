# Azure Container Application Infrastructure

This project contains Infrastructure as Code (IaC) using Azure Bicep for deploying a containerized application with secure networking and load balancing capabilities.

## Architecture Overview

The infrastructure consists of:
- Virtual Network with two subnets
- Network Security Group with strict security rules
- Container Instance with private networking
- Application Gateway for public access and load balancing
- Log Analytics integration for monitoring

## Prerequisites

- Azure CLI installed and configured
- Azure subscription
- Azure Container Registry with your application image
- Log Analytics Workspace
- Visual Studio Code with Bicep extension (recommended)

## Project Structure

```
AzureProject/
├── main.bicep                 # Main deployment template
├── main.parameters.json       # Parameters file (example)
└── modules/
    ├── network.bicep          # Network infrastructure
    ├── container.bicep        # Container instance configuration
    └── appGateway.bicep       # Application Gateway setup
```

## Parameters File Setup

Create a `main.parameters.json` file with the following structure:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
            "value": "westeurope"  // Your preferred Azure region
        },
        "containerGroupName": {
            "value": "your-container-group-name"
        },
        "acrLoginServer": {
            "value": "your-acr.azurecr.io"
        },
        "imageName": {
            "value": "your-image:tag"
        },
        "tokenUsername": {
            "value": "your-acr-username"
        },
        "tokenPassword": {
            "value": "your-acr-password"
        },
        "logAnalyticsWorkspaceId": {
            "value": "your-workspace-id"
        },
        "logAnalyticsWorkspaceKey": {
            "value": "your-workspace-key"
        },
        "vnetName": {
            "value": "your-vnet-name"
        },
        "privateIP": {
            "value": "10.0.1.4"  // Or your preferred private IP
        }
    }
}
```

## Deployment Steps

1. **Login to Azure**
   ```bash
   az login
   ```

2. **Create a Resource Group** (if not exists)
   ```bash
   az group create --name your-resource-group --location westeurope
   ```

3. **Deploy the Infrastructure**
   ```bash
   az deployment group create \
     --name deployment-name \
     --resource-group your-resource-group \
     --template-file main.bicep \
     --parameters @main.parameters.json
   ```

4. **Monitor Deployment**
   ```bash
   az deployment group show \
     --name deployment-name \
     --resource-group your-resource-group \
     --query properties.outputs
   ```

## Network Configuration

- The container instance is deployed with a private IP in the application subnet
- The Application Gateway provides public access to the container
- NSG rules allow:
  - Inbound HTTP traffic from Application Gateway
  - Outbound traffic to Azure Monitor and ACR
  - All other traffic is denied by default

## Monitoring

The deployment includes Log Analytics integration for monitoring:
- Container instance logs
- Application Gateway metrics
- Network flow logs

## Important Notes

- Ensure your ACR credentials are valid and have pull permissions
- Keep your parameters file secure and never commit it to version control
- The private IP (10.0.1.4) should be available in your subnet range
- Application Gateway deployment might take 15-20 minutes

## Troubleshooting

1. **Container Not Starting**
   - Verify ACR credentials
   - Check container logs in Log Analytics
   - Ensure network connectivity to ACR

2. **Application Gateway Issues**
   - Verify backend health probe configuration
   - Check NSG rules are not blocking traffic
   - Review Application Gateway logs

3. **Network Connectivity**
   - Verify subnet delegations
   - Check NSG rules
   - Ensure private IP is available

## Clean Up

To remove all deployed resources:
```bash
az group delete --name your-resource-group
```

## Security Considerations

- All sensitive information should be stored in Azure Key Vault
- Use managed identities where possible
- Regularly rotate ACR credentials
- Monitor security recommendations in Azure Security Center

## Contributing

Feel free to submit issues and enhancement requests!

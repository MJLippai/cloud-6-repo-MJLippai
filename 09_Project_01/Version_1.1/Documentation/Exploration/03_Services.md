## Goal
As a team we want a clear overview of the Cloud Infrastructure required.

----
## Epic
Exploration.

----
## Description
Identify the services that are absent from the provided design. Make an overview of all services.

----
## Deliverable


Present services from v1.1 design updates: 
-   Application gateway : will funnel traffic to VMSS vms as part of the backend pool. In this project also used for TLS/SSL termination. A routing rule is used to redirect HTTP traffic to the HTTPS port in your application gateway.
-   Virtual Machine Scale sets : Flexible orchestration mode used, to allow for all vms to be backed up according to requirements.
-   Auto scale settings (Microsoft.Insights) : A separate resource used to to take care of auto scale settings and metrics.
-   Health Check extension (ApplicationHealthLinux) : Health check extension on the VMSS vms allow for automatic repairs to take place in case of unhealthy vms.
-   NAT gateway : Linked to a public IP. Takes care of enabling outbound connections for the web servers.
-   Azure Policies : Allows setting specific policies resources on specific scopes need to follow. In this case the policy ensure all resources are tagged with the Resource group tag if missing and backups up all vms with this resource tag.
-   

Present services from v1.0 design:  

-   Key Vault : Used to create a key for encryption. Access policies determine who has access to the vault.
-   Role assignments : Some managed identities require specific role assignments to complete the operations under them.
-   Recovery Vault : Used to set a backup policy (frequency/length etc) and configure the items to be backed up.
-   Storage account : Used to store the PostDeployment script in a container.
-   Virtual Networks : To allow the corresponding resources to communicate securely with each other. One Vnet is created for the Web and Admin servers respectively. 
-   Subnets : Smaller networks within the Vnets. 
-   Virtual network peering : Allows the two Vnets 
-   NSGs : In current scenario used to protect the subnets.
-   Web Server : A linux virtual machine with a user data script to install and launch apache2.
-   Management Server : A windows virtual machine meant to function as an admin server for the web server.

Services added during development of project:

-   Encryption Set : Meant to use a customer managed key from the Vault to be able to encrypt the VMs and the Storage Account.
-   Resource Group : Rather then the previously showing Subscription, have decided to show the deployment on the resource group level (as it would have to be in any case).
-   Deployment scripts resource : make use of deployment scripts resource to automate the uploading of the bootstrap script. 

Current Project diagram:  

![Pv1diagram](../../../../00_includes/prj_v1_diagram.png)  

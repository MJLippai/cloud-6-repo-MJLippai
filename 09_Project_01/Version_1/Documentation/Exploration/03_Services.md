## Goal
As a team we want a clear overview of the Cloud Infrastructure required.

----
## Epic
Exploration.

----
## Bescrijving
Identify the services that are absent from the provided design. Make an overview of all services.

----
## Deliverable

Present services from first design:  

-   Key Vault : Used to create a key for encryption. Accesspolies determine who has access to the vault.
-   Recovery Vault : Used to set a backup policy (frequency/length etc) and configure the items to be backed up.
-   Storage account : Used to store the PostDeployment script in a container.
-   Virtual Networks : To allow the corresponding resources to communicate securely with each other. One Vnet is created for the Web and Admin servers respectively. 
-   Subnets : Smaller networks within the Vnets. 
-   Vnet peering : Allows the two vnets 
-   NSGs : In current scenario used to protect the subnets.
-   Web Server : A linux virtual machine with a user data script to install and launch apache2.
-   Management Server : A windows virtual machine meant to function as an admin server for the web server.

Services added during development of project:

-   Encryption Set : Meant to use a customer managed key from the Vault to be able to encrypt the VMs and the Strorage Account.
-   Resource Group : Rather then the previously showing Subcription, have decided to show the deployment on the resource group level (as it would have to be in any case).
-   Deployment scripts resource : make use of deployment scripts resource to automate the uploading of the bootstrap script. 

Current Project diagram:  

![Pv1diagram](../../../../00_includes/prj_v1_diagram.png)  

## Goal
Documentation for the use and deployment of the IAC.

---
## Epic
v1.1

---
## Description
Ensure that the client understands how to use the IAC. Make clear what needs to be configured before the deployment can start en which arguments need to be given.


---
## Deliverable

As one of the requirements of the project is to launch the IAC with one click the required steps to deploy are limited.  
There is some critical information that must be provided.  

Parameters are stored in file [zparam](../../zparam.json).

*Critical*:
-   admintrust - array : should include the list of ips approved for access to the admin server. Even for testing this needs to be adjusted.
-   pubkey - string: replace sample key with a public ssh key in ssh-rsa format for testing.
-   The Windows admin password to be found in the kvptest* vault secrets after deployment.
-   A testing self-signed ssl certificate is provided in the form of file ./appgwcert.pfx this must be changed for production- use same name. 
    Please update also update the required password (secure string in bicep files).

Of importance:
-   environment - string : a value to describe the type of environment, this value is later added to various resources names as part of the naming convention.
-   version tag - object : a key and a value to set as tag for all resources in the form = project_version: '1.0'
-   rsgname - string : a value to describe your Resource group.
-   vm_admin_size - string : provide a size for your windows admin server.
-   vm_webserver_size - string : provide a size for your linux web server.

Of interest:  
-   Parameter 'rsgname' : Be aware that a number of other variables use the corresponding resource ID to generate a unique value. Default value is fine for testing.
-   Parameter 'environment' is currently set to 'test' and is used for the many other naming conventions. Change if needed but keep simple -> keep in 
    mind some naming restrictions (depending on the resource) could derail deployment if there are disapproved characters or if it becomes too long etc.
-   Parameter 'versiontag' is currently set to 'project_version: 1.1 and will be applied to all resources deployed within the group (Azure policy). Some child   
    resources or others do not require or accept a tag.
-   Parameter 'location' is currently set to the location of the deployment. This is applied to the resource group created and in turn all resources deployed within.
-   Bootstrapscript is loaded from file zscipt.sh, in folder bootstrapscript. If you want to change the script please change it here as it is the same file
    uploaded to the encrypted storage account.  

Deploying the IAC:
-   First login with command 'az login' assuming you are using Azure CLI.
-   Once ready to deploy simply use the following command to start deployment : ./deploy.ps1
-   For clarification westeurope (-l or also --location parameters) can be replaced by your desired location of deployment in the deploy.ps1 file. 
    Keeping in mind this will be used for all concurrently deployed resources.

For instructions on producing same results with Powershell : [PS deployment](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-powershell)  

This should conclude any instructions.  
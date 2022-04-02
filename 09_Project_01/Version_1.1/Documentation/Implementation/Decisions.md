## Goal
Decribe your considerations, decisions and the reasoning behind them. 

---
## Epic
Verson 1.0 

---
## Description
Elaborate on your considerations. Describe your decisions and the reasoning behind them. This document should also contain your assumptions and improvements.  
This should be the basis for your Design documentation.  

---
## Deliverable

Assumptions have been provide in the exploration epic : [Assumptions](../Exploration/02_Assumptions.md)

The following are a number of decisions that were made during the development of the IAC:  
-   Setting up logical modules based on grouped dependencies
-   Networking : declare subnets, nsg rules and peering separately as a child resources to avoid circular dependency detection.
-   Key Vault : declare Access policies and key separately as a child resource to avoid circular dependency detection.
-   Make use of deployment script resource to automate uploading of the bootstrap script.
-   Use of 'sym_link' naming convention to indicate a symbolic bicep name.
-   Use of an 'environment' parameter to indicate whether it is a test or production environment.
-   Use of of CustomData with VMSS rather then Userdata as this produces a more consistent and functional result.
-   Bootstrap script is loaded into CustomData during deployment from same file that is uploaded to the storage account as this 
    requires providing less access than referencing the file from the storage account with a url (providing storage account access keys etc).
-   Order of deployment is decided in part implicitly and explicitly. Reasons is strictly decided based on what is dependent on
    another resource in other to go live. This is further illustrated in the Design document and in the order of deployment diagram.
-   Two Key Vaults will be use to be able to segregate one from the other and easily disable the password gen module if so needed.

---
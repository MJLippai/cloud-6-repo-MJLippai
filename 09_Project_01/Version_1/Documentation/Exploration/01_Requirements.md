## Goal
Defining and expanding the requirements of the IAC project and it's deliverables.

---
## Epic
Exploration.

---
## Description
Requirements were provided in the Project document. The list provided was possibly "incomplete or vague".  
This document is meant to further develop the requirements through research and questions to the Product owner.

---
## Deliverable
A list describing all the finalized requirements:
-   All VM disks must be encrypted.
-   The webserver and admin needs to be backed up daily. The backups need to be kept
    for 7 days.
-   The webserver needs to be installed in automated manner.
-   Same bootstrap script used for deployment of webserver must be uploaded to an 
    encrypted storage account.
-   The admin/management server needs to be available through a public IP.
-   The admin/management server must only be reachable from trusted locations 
    (office/home).
-   The following IP ranges will be used: 10.10.10.0/24 & 10.20.20.0/24
-   All subnets must be protected on a subnet level by NSGs.
-   SSH or RDP connections with the webserver can only be achieved from the admin server.
-   Webserver should be a Linux system, while the admin server should be a Windows server.
-   SSH connections to the webserver from the admin server must be accomplished through
    private ips (by way of the Vnet peering).
-   Available budget for the project is both 130 euros for the development of the IAC, and 
    as a monthly cost for the client.
 
Improvements to architecture can be made according to documentation, but priority was set on providing a MVP for V1.0, with V1.1 focusing more on improvements.  
All decisions should be based on above requirements, and will be included in the [Decisions](../../Documentation/Implementation/Decisions.md) document.

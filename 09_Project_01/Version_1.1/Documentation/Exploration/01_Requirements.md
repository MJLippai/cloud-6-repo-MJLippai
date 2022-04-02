## Goal
Defining and expanding the requirements of the IAC project and it's deliverables for v1.1.

---
## Epic
Exploration.

---
## Description
Additional requirements were provided in the Project document v1.1. 
This document is meant to further develop the requirements through a new list provided by the Product owner, that will be (mostly) unavailable for the remainder of the project.

---
## Deliverable
A list describing all the new additional requirements:
-   The web servers should no longer be exposed directly to the internet. The client would prefer to see a load balancer solution be added in between. The servers should no longer have a public IP.
-   If a user makes a HTTP connection with the load balancer, it should be automatically upgraded to HTTPS. This is not allowed to take place on the servers.
-   This connection should be secured with at least TLS 1.2 or higher, but end-to-end is not required.
-   The webserver should regularly undergo a health check.
-   In case of a health check fail then the server should be automatically repaired.
-   Should the web server come under ongoing duress a temporary additional server should be engaged. The client thinks that no more than 3 servers total will ever be required based on past user data.


All decisions should be based on above requirements, and will be included in the [Decisions](../../Documentation/Implementation/Decisions.md) document.

Original v1.0 requirements:  
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
-   Web servers should be a Linux system, while the admin server should be a Windows server.
-   SSH connections to the webserver from the admin server must be accomplished through
    private ips (by way of the Vnet peering).
-   Available budget for the project is both 130 euros for the development of the IAC, and 
    as a monthly cost for the client.
 
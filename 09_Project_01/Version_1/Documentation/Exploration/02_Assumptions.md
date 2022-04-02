## Goal
As a team we would like to make clear all the assumptions that were made during development.

----
## Epic
Exploration.

----
## Description
It is possible that there were questions that none of the stakeholders were able to answer.
Produce an overview of all the assumptions that had to be made because of this.

----
## Deliverable

There were very few questions left unanswered by the stakeholders. Due to budget limitations and the  
nature of the project everything was very clear after some sessions with the Product owner.  

Some assumptions made in relation to best practices and the nature of the project:
-   SSH keys will be used to login to the Web server
-   Hot tier for storage account
-   Loading script into Userdata during VM deployment, rather than using a Custom Script extension

Result of assumptions resolved through meetings with stakeholders:
-   Only NSGs will be used, no full firewalls
-   Webserver should be Linux, Admin should be Windows
-   Storage account as well as Admin server should also be encrypted
-   Logging into Webserver from Admin should happen via the private IPs
-   Budget is 130 Euro for the setting up and also monthly cost of the client
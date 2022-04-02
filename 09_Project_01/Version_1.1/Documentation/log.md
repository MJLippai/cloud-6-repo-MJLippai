## Note: some overlap in days with V1.0 towards conclusion of that version.

# Log [04/03/2022]

## - Daily report -
Waiting to receive full v1.1 requirements, focused on helping classmates and small improvements on code with naming and such.
Got some partial information so started focusing on documentation for load balancers and autoscaling.

## - Challenges -
Mainly documentation review, no challenges.

----
# Log [07/03/2022]

## - Daily report -
Received feedback from Gerard, Sentia buddy, on my delivered v1.0. Going through suggestions on how to improve my code.
Received full v1.1 requirements, started to review and visualize changes to be made.

## - Challenges -
Automate the entering of the ObjectId, the pw generation and vault and starting to use ps1 files to simplify the deployment.

## - Solutions -
Making use of ps1 combines with Powershell commands.

## - Learnings -
Learning to use ps1 files and various PS1 files where to workaround bicep limitations.

----
# Log [08/03/2022]

## - Daily report -
Due to AD restrictions options to retrieve ObjectId were limited. Also started to plan out v1.1 requirements. Looking into load balancers and how to
apply them.

## - Challenges -
Ad limitations. Http to Https redirect with a plain load balancer has to be done on the server.

## - Solutions -
Service research.

## - Learnings -
Various options when it comes to load balancing in Azure.

----
# Log [09/03/2022]

## - Daily report -
Wanted to make the password generation automated, spent day working out a solution that would fill the specific pw requirements.
Continued to research v1.1 requirements. 

## - Challenges -
For the password to be used in later deployments as a secret, it needs to be first generated and stored on higher level or earlier deployment. 


## - Solutions -
For the meantime I've chosen to do automation of pw generation and storing as a separate deployment.

## - Learnings -
PS code to generate passwords with specific requirements, then storing through use of a deployment script resource.

----
# Log [10/03/2022]

## - Daily report -
Completed all feedback received from Sentia to improve v1.0.
Requirements of project do not allow for use of normal load balancer as Product owner does not want the Http to Https redirect to 
happen on the server. Starting to work and research Application Gateways instead.

## - Challenges -
Application gateways have special NSG rule requirements among others. Lot of settings need to be specifically dialed to avoid issues reaching and communicating with servers.

## - Solutions -
Investigating Application gateways.

## - Learnings -
How to configure App gateway to allow for http-> https redirect.

----
# Log [11/03/2022]

## - Daily report -
Presentations day, going through group-mates projects. Reviewing and making last edits to v1.0.

## - Challenges -
None.

## - Solutions -
-

## - Learnings -
Some interesting examples from group class mates on using loops to launch resources.

----
# Log [14/03/2022]

## - Daily report -
Project requirement calls for Flexible orchestration of the scale set to allow backup of all the used vms.
Flexible orchestration requires quite a few adjustments to the IAC and adding a Nat Gateway.

## - Challenges -
Figuring out how to set up automatic backups of the Scale set vms.

## - Solutions -
Use of policies to set all vms created with a certain tag to be backed up.

## - Learnings -
Working with Azure policies and Flexible orchestrated Scale sets and their requirements.

----
# Log [15/03/2022]

## - Daily report -
Troubleshooting various bad nat gateway 502 errors with updated v1.1.

## - Challenges -
Figuring out where the connection was being dropped. Making sure all settings were set correctly.

## - Solutions -
Debugging and testing servers to isolate issue.

## - Learnings -
Nat gateway for outbound connections. Debugging and troubleshooting 502 bad gateway error. Troubleshooting flexible orchestration.

----
# Log [16/03/2022]

## - Daily report -
Setting deployment up in two parts to resolve secret calling requirements.

## - Challenges -
getSecret function only works on an already existing vault so naturally this has to be deployed before it has to be called.

## - Solutions -
Playing around with different options. 

## - Learnings -
Multiple deployments combined through a ps1 file.

----
# Log [17/03/2022]

## - Daily report -
Learning to extract values from json files manually to avoid using multiple parameters files.

## - Challenges -
Pulling objects from the json file can be complicated and then referencing them as individual values is not a great work around. Looking into other options.

## - Solutions -
Learning functions to extra and reference values from json files.

## - Learnings -
Pulling values from json parameter file in another deployment is possible but also not elegant. Can use same parameter file in multiple main bicep files due to certain rules but it comes with other challenges.

----
# Log [18/03/2022]

## - Daily report -
Restructuring deployment from multiple separate deployments launched by a ps1 file into one multi-layered bicep deployment, meaning nested modules. 

## - Challenges -
Files had to be linked in the new structure to reflect the nested modules but overall it was simpler and cleaner than the previous setup.

## - Solutions -
I already had some experience by this point with modules; however the idea of nested modules to simplify dependencies came from some github examples.

## - Learnings -
Proper nesting can facilitate various resource referencing dependencies and complications.
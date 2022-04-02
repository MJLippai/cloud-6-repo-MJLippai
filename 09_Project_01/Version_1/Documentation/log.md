# Log [08/02/2022]

## - Daily report -
Finalizing Python exercises.

## - Challenges -
Some complications trying to save to the CSV in the exact format I wanted.

## - Solutions -
Found article with providing the correct syntax to solve the formatting into columns by importorting csv and usign DictWriter (with fieldnames).

## - Learnings -  
Use if csv library with previous knowledge to solve problem.  

---- 
# Log [09/02/2022]

## - Daily report -
Getting familiar with Bicep through Azure documentation and videos.

## - Challenges -
Zero experience with Bicep.

## - Solutions -
Study and experiment.

## - Learnings -  
Behind the scenes, Resource Manager still operates based on the same JSON templates. Bicep is simply a more declarative way of writing the same IAC ARM templates.    Setup of VS with necessary plugins complete, as well as instelled Bicep through Powershell to be able to use it via the terminal.  

---- 
# Log [10/02/2022]

## - Daily report -
Starting learning path Bicep on Azure.

## - Challenges -
Setting up VS with plugins and installing bicep.  
Testing setup and deploying first scripts.  

## - Solutions -
Following tutorials and studying documentation.  

## - Learnings -
How to work with bicep files and corresponding json ARM templates.  
Way bicep works with implicit and explicit dependengicies. 

---- 
# Log [11/02/2022]

## - Daily report -
Continuing learning path Bicep on Azure while starting to plan out project.

## - Challenges -
Converting ARM templates from Portal with json to bicep. Learning to clean up the differences/errors not handled by decompilation.  

## - Solutions -
Trial and error.  

## - Learnings -
The way Azure ARM templates appear in the portal are not the same templates you can use to deploy them. Many changes need to be made.  
Comparing available basic templates from bicep github and azure quickstarts with the templates from the live versions can help solve the adjustments needed.  

---- 
# Log [11/02/2022]
Python final day for cohort and knowledge check.

## - Daily report -
Mainly refreshing for quiz and going over scripts and results with group.

## - Challenges -
None.

## - Learnings -
Various learnings from comparing scripts with groups. Different solutions for same problems expands on how you can tackle problems later on.

---- 
# Log [14/02/2022]

## - Daily report -
Continuing learning path Bicep on Azure while starting to plan out project. Sharing resources found with others.

## - Challenges -
Converting ARM templates from Portal with json to bicep. Learning to clean up the differences/errors not handled by decompilation.  

## - Solutions -
Trial and error.  

## - Learnings -
The way Azure ARM templates appear in the portal are not the same templates you can use to deploy them. Many changes need to be made.  
Comparing available basic templates from bicep github and azure quickstarts with the templates from the live versions can help solve the adjustments needed.  

---- 
# Log [15/02/2022]

## - Daily report -
Learning to solve various error thrown with bicep deployments. Splitting up templates into smaller pieces and continuing getting familiar with code.  
Also continuing learning path and watching bicep related videos.  

## - Challenges -
Errors not always clear on what level there is an error though they do always give some indication of where to look for issues.  

## - Solutions -
Trial and error, checking stackoverflow and other sources.   

## - Learnings -
Work in small batches of code, build on working code progressively. How to hunt down source of errors through testing and comparisons etc.  

---- 
# Log [16/02/2022]

## - Daily report -
Focusing on dependencies and how to avoid circular dependency detection by breaking up resources into child sources.

## - Challenges -
There are various ways of referencing a parent/child or having to take dependencies into account when building IAC.

## - Solutions -
Going through Azure documentation to figure out ways of using parent/child resources or setting dependenies explicitly to ensure resources are launched in correct order.   

## - Learnings -
How to make use of parent child resources to avoid errors or simply make code more readable.  

---- 
# Log [17/02/2022]

## - Daily report -
Working on Network segment of IAC. Making sure all components work. 

## - Challenges -
Peerings can cause circular dependeny with the way they are shown in the ARM template from Portal (live resources).  

## - Solutions -
Comparing template codes with live versions. Breaking up resources to avoid depencies.  
Quite a bit of duplicate code in live versions that was unneeded so lot of cleaning up.  

## - Learnings -
Making more use of parameters and how to set up specific resources. In this case related to Network mostly.  

---- 
# Log [18/02/2022]

## - Daily report -
Figuring out a solution for using user assigned identities to get around our restrictions with AD to be able to make Storage account (and VMs) encrypted with cmk.

## - Challenges -
Was not at first clear how to get around not using AD.

## - Solutions -
With assistance from LearningCoach we tested some options with User assigned identities to resolve the requirements of deployment of said resources.

## - Learnings -
Usually multiple ways of solving issues, when limitations are involved.  

----
# Log [21/02/2022]

## - Daily report -
Trying to find a way to upload a script to a storageaccount as part of the bicep deployment.

## - Challenges -
There are limited ways to accomplish this during bicep deployment as you must run Azure CLI or Powershell commands to make this possible.  

## - Solutions -
Solution found on a github source. Deployment scripts combined with syntax within that allows you to load the file as base64 (otherwise  
the spaces were being lost, and Custom script can directly use a bootstrap script if in base64 encoding).  

## - Learnings -
Making more use of parameters and how to set up specific resources. In this case related to Network mostly.  

---- 
# Log [22/02/2022]

## - Daily report -
Finalizing the modularization layout to start splitting up the main code. Testing use of outputs and going through documentation.

## - Challenges -
Deciding what modules and resources to group. 

## - Solutions -
Checking working IAC examples to see how people implement best practices related to these concepts.

## - Learnings -
Groupings based on dependencies results in limited outputs needing to be generated later on while still being very useful on regards to clarity and possibly further modularization.  

----
# Log [23/02/2022]

## - Daily report -
Focusing on error generated when trying to make use of the encryptionset.

## - Challenges -
Keey keeps giving an error related to keyvault access.  


## - Solutions -
Checking documentation, other similar reports. Comparing similar templates to my syntax. 

## - Learnings -

Aside from Access policies, keys themselves also have specific operations set on creation which depict what they are allowed to be used for.  
This was previoudly not clear from any examples found.  

---- 
# Log [24/02/2022]

## - Daily report -
Cleaning up of code.  
Further modularizing of the bicep code in seperate compartments.  Mainly machine module today which is very dependent on both network and vault.  

## - Challenges -
Setting up module outputs to be used across each others.  


## - Solutions -
Systematic application of bicep best practises to working code.

## - Learnings -
How to extract various outputs and call them in other modules.  
How to deal with various intellisense bicep notifications to improve code.

----
# Log [25/02/2022]

## - Daily report -
Preparing and delivery of presentation progress of V1.0. Main thing still pending is recovery vault and documentation.

## - Challenges -
Providing a clear overview of progress so far. 

## - Solutions -
Delivered a short presentation highlighting the road to V1.0. Of note was the modularized IAC presented through the visualizer. Then jumped over to the code and gave a step by step breakdown of what I've accomplished.

## - Learnings -
Mainly where everyone is in the project so far.

----
# Log [25/02/2022]

## - Daily report -
Finished creating recovery module. Finished some outstanding tasks for network. Various tests made, focuses on network restrictions but also with completed IAC. Everything seems to be working.

## - Challenges -
Beckup items need to be defined in a very specific way (to illustrate their particular child status), however the learnings so far provided to translate very well to developing the recovery vault and it deployed first try.

## - Solutions -
Apply previous learnings to recovery vault and use bicep documentation for backup items.

## - Learnings -
How to declare the backup items in with correct naming convention.

----
# Log [01/03/2022]

## - Daily report -
Further cleaning up of code, tidying up parameters and names. Also focusing on backlog of documentation to complete documentation.
Some additional testing after changes to make sure nothing broke.

## - Challenges -
Writing proper documentation to accompany the code is a new experience. Some doubts on what to include or leave out with project with such clear boundaries and requirements.  

## - Solutions -
Hope to get some feedback tomorrow with a review of my code delivery of V1.0.

## - Learnings -
What should be included in documentation and what to avoid.  

----
# Log [01/03/2022]

## - Daily report -
Setting up of a parameter file so client only has to change files in one place.

## - Challenges -
Mainly have been working in Bicep so far and parameter is in Json, which has other syntax etc and have had limited experience with.

## - Solutions -
Learn to work with Json through documentation.

## - Learnings -
Limitations and how to create parameter file.

----
# Log [02/03/2022]

## - Daily report -
Finalizing and testing of parameter file and updating documentation.

## - Challenges -
Calling secrets within parameter file in Json syntax.

## - Solutions -
Investigate documentation.

## - Learnings -
What should go into parameter file and how to declare it.

----
# Log [03/03/2022]

## - Daily report -
Delivering v1.0 to TG and getting feedback. Mainly positive.

## - Learnings -
Making small edits to code based on TG feedback, mainly about documentation.

----
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
Due to AD restrictions options to retrieve ObjectId were limited. Also started to plan out v1.1 requirements. Looking into loadbalancers and how to
apply them.

## - Challenges -
Ad limitations. Http to Https redirect with a plain loadbalancer has to be done on the server.

## - Solutions -
Service research.

## - Learnings -
Various options when it comes to loadbalancing in Azure.

----
# Log [09/03/2022]

## - Daily report -
Wanted to make the password generation automated, spent day working out a solution that would fill the specific pw requirements.
Continued to research v1.1 requirements. 

## - Challenges -
For the password to be used in later deployments as a secret, it needs to be first generated and stored on higher level or earlier deployment. 


## - Solutions -
For the meantime I've chosen to do automation of pw generation and storing as seperate deployment.

## - Learnings -
PS code to generate passwords with specific requirements, then storing through use of a deployment script resource.

----
# Log [10/03/2022]

## - Daily report -
Completed all feedback received from Sentia to improve v1.0.
Requirements of project do not allow for use of normal loadbalancer as Product owner does not want the Http to Https redirect to 
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
Presentations day, going through groupmates projects. Reviewing and making last edits to v1.0.

## - Challenges -
None.

## - Solutions -
-

## - Learnings -
Some interesting examples from group class mates on using loops to launch resources.

----

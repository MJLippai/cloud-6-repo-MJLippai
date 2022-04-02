## Introduction 
----

Everything we have learned so far throughout this Techgrounds course has prepared us for the Project at hand.  
This project is meant to test not only our ability to develop IAC but acquire new knowledge and skills, in this case how  
to make use of bicep, in order to accomplish our goal.  
  
Bicep is a relatively new language, with the latest version as of this writing being v0.4.1272. It is an  
improvement over ARM templates in that it is a much more readable language and also has some helpful functionalities
such as the ability to build modules. However being new it does have the challenge that some kinks are still being 
worked out and it is not as widely adopted as some older languages (less YT videos, freely available courses etc).

Regardless Microsoft has provided a wealth of resources in the form of their usual documentation, many samples and
learning modules to help facilitate the adopt of this domain-specific language.

## Project Version 1.0
----
In version 1.0 the requirements of the project have been very clearly defined from the start with some further clarification  
provided through meetings with Coen MeulenKamp, our Product Owner. The essence of this project is really learning to  
work with many different services, which in some cases need to refer back to each other in various ways. This can cause  
complications, primarily circular dependencies.  

In short the project was meant to provide IAC that could launch the corresponding architecture with one command. The architecture  
was in broad strokes meant to contain:

-   an encrypted web and admin server on seperate availability zones.
-   2 peered vnets, each with a NSG protected subnet, which in turn contain one of the vms each.
-   an encrypted storage container containing a bootstrap script.
-   recovery vault for backups.
-   key vault to enable encryptions.

For complete details the project please look to the following deliverables.  

Exploration:  
 [Requirements](./Documentation/Exploration/01_Requirements.md)  
 [Assumptions](./Documentation/Exploration/02_Assumptions.md)  
 [Services](./Documentation/Exploration/03_Services.md)  
  
Implementation:  
[Design](./Documentation/Implementation/Design.md)  - > See visual overviews of Project V1.0.  
[Decisions](./Documentation/Implementation/Decisions.md)  
[Instructions](./Documentation/Implementation/Instructions.md)  
  
## Sources and solutions
----
For a large part the primary source was simply the Azure Portal. By downloading live architecture ARM templates,  
decompiling and compairing with more standardized sample bicep templates this provided a systematic process for  
developing the required IAC.

Additional sources referenced during the development of this project were:  

[Bicep Learn path](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/learn-bicep)  
[Bicep Github examples](https://github.com/Azure/bicep/tree/main/docs/examples)  
[Azure Quickstarts Github](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts) -> Corresponding Bicep templates often included here but not on Quikstarts frontend.  
[Stackoverflow](https://stackoverflow.com/)

Lastly naturally Techgrounds, Coen and Mandy.
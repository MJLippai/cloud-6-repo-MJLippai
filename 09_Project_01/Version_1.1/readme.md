## Introduction 
----

**This entry represents version 1.1 which will build on version 1.0, with various improvements.**

Everything we have learned so far throughout this Techgrounds course has prepared us for the Project at hand.  
This project is meant to test not only our ability to develop IAC but acquire new knowledge and skills, in this case how  
to make use of bicep, in order to accomplish our goal.  
  
Bicep is a relatively new language, with the latest version as of this writing being v0.4.1272. It is an  
improvement over ARM templates in that it is a much more readable language and also has some helpful functionalities
such as the ability to build modules. However being new it does have the challenge that some kinks are still being 
worked out and it is not as widely adopted as some older languages (less YT videos, freely available courses etc).

Regardless Microsoft has provided a wealth of resources in the form of their usual documentation, many samples and
learning modules to help facilitate the adopt of this domain-specific language.

**To jump straight to a visual overview of the project V1.1 please see** [Design](./Documentation/Implementation/Design.md).
   
## Project Version 1.1
----
In version 1.1 the requirements of the project have expanded upon, requiring the implementation of various additional services.  
The essence of this versions changes is to be able to take what we build previously and adapt it to meet new requirements.

The project is still meant to provide IAC that can launch the corresponding architecture with one command.  
The changes that come with v1.1 can be summarized as follows:  

-   make use of a Application gateway to spread the workload and perform SSL/TLS termination.
-   Use autoscaling that adapts according to performance metrics.
-   Auto-repair should take place if the machines report an unhealthy status.  

For complete details the project please look to the following deliverables (includes V1.0 requirements).  

Exploration:  
 [Requirements](./Documentation/Exploration/01_Requirements.md)  
 [Assumptions](./Documentation/Exploration/02_Assumptions.md)  
 [Services](./Documentation/Exploration/03_Services.md)  
  
Implementation:  
[Design](./Documentation/Implementation/Design.md)  - > See visual overviews of Project V1.1.  
[Decisions](./Documentation/Implementation/Decisions.md)  
[Instructions](./Documentation/Implementation/Instructions.md)  
  
## Sources and solutions
----
For a large part the primary source was simply the Azure Portal. By downloading live architecture ARM templates,  
decompiling and comparing with more standardized sample bicep templates this provided a systematic process for  
developing the required IAC.

Additional sources referenced during the development of this project were:  

[Bicep Learn path](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/learn-bicep)  
[Bicep Github examples](https://github.com/Azure/bicep/tree/main/docs/examples)  
[Azure Quickstarts Github](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts) -> Corresponding Bicep templates often included here but not on Quikstarts frontend.  
[Stackoverflow](https://stackoverflow.com/)

Lastly naturally Techgrounds, Coen and Mandy.
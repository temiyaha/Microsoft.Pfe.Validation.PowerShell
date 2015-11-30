# Microsoft.Pfe.Validation.PowerShell
Microsoft.Pfe.Validator.PowerShell is a validation framework to validate your system. Write your own validator to extend the framework!

#Overview

There are many systems you need to validate and you also need to monitor the validation results. And there are so many ways to achieve the same. So which one to choose? Microsoft.Pfe.Validator.PowerShell is our suggestion to PowerShell lovers. This module consists of followings.

###Microsoft.Pfe.Validator.PowerShell

This is a main module you can download from this page which contains several functions to load and execute validation modules, and display the result.

###Validation Modules

We provide module template how to write the validation as Interface. You store each validation modules (.psm1 file) under validators folder.

###Validator Settings

Validator Settings contain necessary information to execute each validation module. You can load these parameters from CSV, Text or construct it by yourself.

***Category:*** Validation Category Name. Any name is fine.

***ValidatorName:*** Validator module name. The module has to exist under validators folder as psm1 file.

***ValidatorParameter:*** Parameters to pass to the validator module. Use "{ 'Param1Name':'Param1Value', 'Param2Name':'Param2Value' }" format. Each validator may take different parameter set.

***DesiredValue:*** A value to compare with Actual value.

###How to setup modules

1. Download Microsoft.Pfe.Validator.PowerShell .zip.

2. Right click the downloaded zip file and click "Properties".

3. Check "Unblock" checkbox and click "OK", or simply click "Unblock" button depending on OS versions.

4. Extract the zip file and copy "Microsoft.Pfe.Validator.PowerShell   " folder to one of the following folders: 
    • %USERPROFILE%\Documents\WindowsPowerShell\Modules 
    • %WINDIR%\System32\WindowsPowerShell\v1.0\Modules  

5 As this module is not signed, you may need to change Execution Policy to load the module. You can do so by executing following command.  


```PowerShell
Set-ExecutionPolicy –ExecutionPolicy RemoteSigned –Scope CurrentUser
```

Please refer to Set-ExecutionPolicy for more information.

6. Open PowerShell and run following command to load the module.


```PowerShell
# Import the module 
Import-Module Microsoft.Pfe.Validator.PowerShell
```

*The module requires PowerShell v3.0. However,  higher version might be required depending on a validator.

###How module works

First of all, create ValidationSettings either from file or directly construct them, and pass it to Start-Validation Function. You can use Format-ValidationReusltToConsole to display the result in user friendly way. Following example shows how to create ValidationSettings inside script and passes it to Start-Validation, which end up passing the result to Format-ValidationResultToConsole to format the result.


```PowerShell
# Create Validator Setting. In this example, using Microsoft.Pfe.WindowsService validator which check if the service exists and running.  
# It takes two parameters TargetServer and ServiceName. 
# See Microsoft.Pfe.WindowsService.psm1 file under Validators folder for actual script. 
$validatorSettings =  
    @{Category="Service Check";ValidatorName="Microsoft.Pfe.WindowsService";ValidatorParameter="{ TargetServer:'localhost', ServiceName:'Spooler' }","DesiredValue="Runinng"}, 
    @{Category="Service Check";ValidatorName="Microsoft.Pfe.WindowsService";ValidatorParameter="{ TargetServer:'localhost', ServiceName:'LanmanServer' }","DesiredValue="Runinng"} 
 
# Pass the parameter to Start-Validation. 
$validatorSettings | Start-Validation | Format-ValidationReusltToConsole
```

The "Microsoft.Pfe.WindowsService" validator is part of sample so you can try this immediately.

###How to write Validator

Though we provide validators, we need you to write your own validator because each system requires different set of validation. To write a validator, start from Microsoft.Pfe.Validator.Template.psm1 which you find under Validators folder, or see the existing sample validator. Each validator must have three functions.

***[Get-ActualValue]***

This function returns a value to compare with Desired Value. If you validate performance of particular operation, it should return performance related value, or if you check the status, it should return status information. If you use parameter, we recommend you to document what parameters are expected clearly.

***[Get-Result]***

This function returns validation result. You can decide when to return true/false depending on your scenario. For exmaple, if you are validating performance of an operation, you may return true when actual value is less then desired value.

***[Get-EnvironmentName]***

This function simply returns Environment information as string. It maybe server name where you run validation against, or Web URL.

###How to create Validator Settings

Validator settings contains enough information to execute each validator. You can create them in may ways, but we introduce two examples here.

***[Use CSV]***

If you want to use CSV, use following format.

Category,ValidatorName,ValidatorParameter,DesiredValue
 ServiceCheck,Microsoft.Pfe.WindowsService,"{ TargetServer:'localhost', ServiceName:'Spooler' }",Running
 ServiceCheck,Microsoft.Pfe.WindowsService,"{ TargetServer:'localhost', ServiceName:'LanmanServer' }",Running



Once you saved it to csv file, then you can read it by using Import-CSV function. Following sample code asusme you saved the csv file as setting.csv in current folder.

```PowerShell
Import-Csv -Path .\settings.csv | Start-Validation | Format-ValidationReusltToConsole
```

###[Use PowerShell Script]

 

If you want to create the settings in .ps1, then use the following example.

```PowerShell


# Create Validator Setting. 
$validatorSettings =  
    @{Category="Service Check";ValidatorName="Microsoft.Pfe.WindowsService";ValidatorParameter="{ TargetServer:'localhost', ServiceName:'Spooler' }","DesiredValue="Runinng"}, 
    @{Category="Service Check";ValidatorName="Microsoft.Pfe.WindowsService";ValidatorParameter="{ TargetServer:'localhost', ServiceName:'LanmanServer' }","DesiredValue="Runinng"} 
 
# Pass the parameter to Start-Validation. 
$validatorSettings | Start-Validation | Format-ValidationReusltToConsole
```

###About Authors

This module is implemented by Takeshi Katano, Yoshihiro Daicho, Kenichiro Nakamura and Tetsuo Miyahara.


Takeshi Katano, Premier Field Engineer, is based out of Japan and works supporting Premier customers.
Yoshihiro Daicho, Sr. Premier Field Engineer, is based out of Japan and works supporting Premier customers.
Kenichiro Nakamura, Sr. Premier Mission Critical Solution Engineer, is based out of Japan and works supporting PMC customers.
Tetsuo Miyahara, Premier Mission Critical Solution Engineer, is based out of Japan and works supporting PMC customers.       

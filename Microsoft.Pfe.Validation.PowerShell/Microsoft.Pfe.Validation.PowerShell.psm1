#
# Copyright © Microsoft Corporation. All Rights Reserved.
# This code released under the terms of the 
# Microsoft Public License (MS-PL, http://opensource.org/licenses/ms-pl.html.)
# Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
# THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE. 
# We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that. 
# You agree: 
# (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
# (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; 
# and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise or result from the use or distribution of the Sample Code 
#

function Start-Validation
{
<#
 .SYNOPSIS
 Accepts validator settings from parameter and execute each validator. Then construct result set. 

 .DESCRIPTION
 The Start-Validation cmdlet lets you run validators and returns result. 

 .PARAMETER ValidatorSetting
 Setting object needs to have following properties.
 Category: Validation Category Name.
 ValidatorName: Validator module name.
 ValidatorParameter: Parameters to pass to the validator module. Use "{ 'Param1Name':'Param1Value', 'Param2Name':'Param2Value' }" format.
 DesiredValue: A value to compare with Actual value.
  
 .EXAMPLE
 Import-Csv -Path .\settings.csv | Start-Validation | Format-ValidationReusltToConsole

 This example read ValidatorSettings from csv file and passes to Start-Validation function. 
 Then it displays the result to console by using Format-ValidationReusltToConsole function.

 .EXAMPLE 
 C:\PS>$validatorSettings = 
    @{Category="MyCategory";ValidatorName="MyValidator1";ValidatorParameter="{ 'Param1Name':'Param1Value', 'Param2Name':'Param2Value' }";DesiredValue="MyValue1"},
    @{Category="MyCategory";ValidatorName="MyValidator2";ValidatorParameter="{ 'Param1Name':'Param1Value'}";DesiredValue="MyValue2"},
    
 C:\PS>$validatorSettings | Start-Validation | Format-ValidationReusltToConsole

 This example creates settings and passes to Start-Validation function.  
 Then it displays the result to console by using Format-ValidationReusltToConsole function. 

#>
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject] $ValidatorSetting
    )

    begin
    {
        Import-Module Microsoft.Pfe.Validation.PowerShell
        $validatorStorePath = Join-Path -Path (Get-Module Microsoft.Pfe.Validation.PowerShell).ModuleBase -ChildPath validators
    }

    process
    {           
        # Create validator module path.
        $validatorFileName = '{0}.psm1' -f $ValidatorSetting.ValidatorName
        $moduleName = Join-Path -Path $ValidatorStorePath -ChildPath $validatorFileName -Resolve -ErrorAction SilentlyContinue
        if($moduleName -eq $null){ return }

        # Import validator module.
        $validatorModule = Import-Module -Prefix 'PFE' -Name $moduleName -PassThru 
        
        # Get parameters for validator.
        $validatorParameter = ConvertFrom-Json -InputObject $ValidatorSetting.ValidatorParameter

        # Retrieve the desired value and actual value.
        $desiredValue = $ValidatorSetting.DesiredValue
        $actualvalue = Get-PFEActualValue -Parameter $validatorParameter

        # Build result object.
        $result = [PSObject] @{
            Timestamp          = [DateTime]::Now
            ValidatorName      = $ValidatorSetting.ValidatorName
            ValidatorParameter = $ValidatorSetting.ValidatorParameter
            Category           = $ValidatorSetting.Category
            EnvironmentName    = Get-PFEEnvironmentName -Parameter $validatorParameter
            DesiredValue       = $desiredValue
            ActualValue        = $actualvalue
            Result             = Get-PFEResult -DesiredValue $desiredValue -ActualValue $actualvalue
        }

        # Send result object to pipeline.
        $result | Write-Output

        # Remove validator module.
        $validatorModule | Remove-Module
    }
}

function Format-ValidationReusltToConsole
{
<#
 .SYNOPSIS
 Display validator results to console.

 .DESCRIPTION
 The Format-ValidationReusltToConsole cmdlet lets you see the validator results on console. 

 .PARAMETER Result to console.
 Result to display.

 .EXAMPLE
 Import-Csv -Path .\settings.csv | Start-Validation | Format-ValidationReusltToConsole

 This example read ValidatorSettings from csv file and passes to Start-Validation function. 
 Then it displays the result to console by using Format-ValidationReusltToConsole function.

 .EXAMPLE 
 C:\PS>$validatorSettings = 
    @{Category="MyCategory";ValidatorName="MyValidator1";ValidatorParameter="{ 'Param1Name':'Param1Value', 'Param2Name':'Param2Value' }";DesiredValue="MyValue1"},
    @{Category="MyCategory";ValidatorName="MyValidator2";ValidatorParameter="{ 'Param1Name':'Param1Value'}";DesiredValue="MyValue2"},
    
 C:\PS>$validatorSettings | Start-Validation | Format-ValidationReusltToConsole

 This example creates settings and passes to Start-Validation function.  
 Then it displays the result to console by using Format-ValidationReusltToConsole function. 

#>
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject] $Result
    )

    process
    {        
        Write-Host ('[{0}] ' -f $Result.Category) -NoNewLine

        $foregroundColor = if ($Result.Result) { 'Green' } else { 'Red' }
        Write-Host ('{0}:{1}' -f $Result.DesiredValue, $Result.ActualValue) -ForegroundColor $foregroundColor -NoNewLine

        Write-Host (' {0}' -f $Result.ValidatorParameter)        
    }
}

function Format-ValidationReusltToAzureAutomation
{
<#
 .SYNOPSIS
 Display validator results to Azure Automation Console.

 .DESCRIPTION
 The Format-ValidationReusltToAzureAutomation cmdlet lets you see the validator results on Azure Automation Console. 

 .PARAMETER Result
 Result to display.
  
 .EXAMPLE 
 C:\PS>$validatorSettings = 
    @{Category="MyCategory";ValidatorName="MyValidator1";ValidatorParameter="{ 'Param1Name':'Param1Value', 'Param2Name':'Param2Value' }";DesiredValue="MyValue1"},
    @{Category="MyCategory";ValidatorName="MyValidator2";ValidatorParameter="{ 'Param1Name':'Param1Value'}";DesiredValue="MyValue2"},
    
 C:\PS>$validatorSettings | Start-Validation | Format-ValidationReusltToAzureAutomation

 This example creates settings and passes to Start-Validation function.  
 Then it displays the result to console by using Format-ValidationReusltToAzureAutomation function. 
#>
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject] $Result
    )

    process
    {        
        Write-Output ('[{0}] {1}:{2} {3}' -f $Result.Category, $Result.DesiredValue, $Result.ActualValue, $Result.ValidatorParameter)
    }
}
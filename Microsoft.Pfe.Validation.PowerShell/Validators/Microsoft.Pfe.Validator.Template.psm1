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


# This function return actual service status.
function Get-ActualValue
{
    [OutputType([Object])]
    param(
        [Parameter(Mandatory = $true)]
        [PSObject] $Parameter
    )

    # Get the value
}

# This function compare desired value and actual value. And return True or False.
function Get-Result
{
    [OutputType([bool])]
    param (
        [Parameter(Mandatory = $true)]
        [Object] $DesiredValue,

        [Parameter(Mandatory = $true)]
        [Object] $ActualValue
    )

    # Compare desired value and actual value. Return True or False.
    # This example returns true if Desired and Actual are equal.
    return $DesiredValue -ceq $ActualValue
}

# This function return the EnvironmentName. EnvironmentName is the source of ActualValue and Results.
function Get-EnvironmentName
{
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [PSObject] $Parameter
    )

    # Return the source of ActualValue and Results.
    return $Parameter.TargetServer
}

# Exposing interface functions.
Export-ModuleMember -Function 'Get-ActualValue','Get-Result','Get-EnvironmentName'

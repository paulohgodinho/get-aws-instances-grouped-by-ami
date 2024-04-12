[CmdletBinding()]
param (
    [string]$Region = "us-east-1"
)

. $PSScriptRoot/Logger.ps1

LogVerbose -Message "Calling 'aws ec2 describe-instances' - Region $Region"

$instances = @()
$paginationToken = ""
while ($true) {
    $result = aws ec2 describe-instances `
        --region $Region `
        --max-items 50 `
        --page-size 25 `
        --starting-token $paginationToken `
        --cli-connect-timeout 300 `
        --cli-read-timeout 300 `
        --output json

    if($LASTEXITCODE -ne 0) {
        LogError -Message "Issue with calling AWS CLI, see error above"
        throw
    }

    $asObject = $result | ConvertFrom-Json

    if($null -eq $asObject.Reservations.Instances) {
        LogVerbose -Message "No Instances found"
        return $null
    }

    $instances += $asObject.Reservations.Instances

    if ($null -eq $asObject.NextToken) {
        LogVerbose -Message "Finished Describe Instance Calls"
        break
    }
    
    LogVerbose -Message "Fetching next page"
    $paginationToken = $asObject.NextToken
}

LogVerbose -Message "Total Instances: $($instances.Count)"
return $instances

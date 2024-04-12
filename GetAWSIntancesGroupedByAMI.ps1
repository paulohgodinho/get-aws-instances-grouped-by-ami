[CmdletBinding()]
Param(
    [string]$Region = "us-east-1"
)

$ErrorActionPreference = 'Stop'
. $PSScriptRoot/helpers/Logger.ps1

class AmiDetails {
    [string]$ImageName = "null"
    [string]$ImageDescription = "null"
    [string]$ImageLocation = "null"
    [string]$OwnerId = "null"
    [string[]]$InstanceIds = @()
}

LogVerbose -Message "Working in Region $Region"

$instances = & "$PSScriptRoot/helpers/DescribeInstancesInCurrentAccount.ps1" -Region $Region

if($null -eq $instances)
{
    LogVerbose -Message "No Instances found"
    return Write-Host "{}"
}

# Display table with AMI|InstanceCount if on Verbose mode
if($VerbosePreference -eq 'Continue') {
    $amiAndInstanceCountTable= $instances | Group-Object -Property "ImageId" -NoElement | Sort-Object Count -Descending
    LogVerbose -Message "$($amiAndInstanceCountTable | Format-Table -AutoSize | Out-String)"
}

$amisBeingUsed = $instances | Select-Object -ExpandProperty ImageId -Unique
$amisDetails = & "$PSScriptRoot/helpers/DescribeAMIsByIdInCurrentAccount.ps1" -Region $Region -ImageIds $amisBeingUsed

$response = @{}
foreach ($amiId in $amisBeingUsed)
{    
    $ami = $amisDetails | Where-Object -Property ImageId -EQ -Value $amiId

    $amiDetails = [AmiDetails]::new()
    $amiDetails.ImageDescription = $ami.ImageDescription
    $amiDetails.OwnerId = $ami.OwnerId
    $amiDetails.ImageLocation = $ami.ImageLocation
    $amiDetails.ImageName = $ami.ImageName
    $amiDetails.InstanceIds = $instances | Where-Object -Property ImageId -EQ -Value $ami.ImageId | Select-Object -ExpandProperty InstanceId

    # Enforcing 'null' rule for empty strings
    foreach($member in $amiDetails.PSObject.Properties) {
        if($member.Value -eq "") {
            $member.Value = "null"
        }
    }

    $response | Add-Member -MemberType NoteProperty -Name $amiId -Value $amiDetails
}

return $response | ConvertTo-Json
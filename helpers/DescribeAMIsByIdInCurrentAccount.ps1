param (
    [string]$Region = "us-east-1",
    [string]$Scope = "self",
    [string[]]$ImageIds
)

. $PSScriptRoot/Logger.ps1

LogVerbose -Message "Calling 'aws ec2 describe-images' with $($ImageIds.Count) Image Ids - Region $Region"

$result = aws ec2 describe-images `
    --image-ids $ImageIds `
    --region $Region `
    --cli-connect-timeout 300 `
    --cli-read-timeout 300 `
    --output json `

if ($LASTEXITCODE -ne 0) {
    LogError -Message "Issue with calling AWS CLI, see error above"
    throw
}

$asObject = $result | ConvertFrom-Json
$images = $asObject.Images

LogVerbose -Message "Total Images: $($images.Count)"
return $images

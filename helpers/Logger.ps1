function LogVerbose {
    [CmdletBinding()]
    param (
        [string]$Message
    )
    $callerName = $MyInvocation.PSCommandPath | Split-Path -LeafBase
    return Write-Verbose "[$callerName] $Message"
}

function LogError {
    [CmdletBinding()]
    param (
        [string]$Message
    )
    $callerName = $MyInvocation.PSCommandPath | Split-Path -LeafBase
    return Write-Error "[$callerName] $Message"
}
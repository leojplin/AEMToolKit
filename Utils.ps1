
function Get-BasicAuthorizationValue {
    param (
        [String]$username,
        [String]$password
    )
    
    $pair = "$($username):$($password)"
    $cred = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
    "Basic $cred"
    
}

function Load-AEMEnvs {
    $path = "$env:userprofile\.aemEnv"
    if (Test-Path $path) {
        $Script:aemEnv = Import-Csv $path
    }
}

Load-AEMEnvs



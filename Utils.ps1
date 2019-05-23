
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
    if (Test-Path "$env:userprofile\test.csv") {
        $Script:aemEnv = Import-Csv "$env:userprofile\test.csv"
    }
}

Load-AEMEnvs



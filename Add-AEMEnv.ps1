class aemEnv {
    [String]$name
    [String]$url
    [String]$username
    [String]$password
}

function Add-AEMEnv {

    [CmdletBinding()]
    param (

        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $ServerName,

        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $Url,

        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $Username,

        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $Password
        
    )
    
    begin {
        
    }
    
    process {
        
        $server = $aemEnv | Where-Object -Property name -Value $ServerName -eq
        if ($server -eq $null) {
            Write-Error -Message "ServerName $ServerName already exists, please use a different name."
            return;
        }

        $env = [aemEnv]::new();
        $env.url = $Url;
        $env.name = $ServerName;
        $env.username = $Username;
        $env.password = $Password;
        
        $env | Export-Csv "$env:userprofile\test.csv" -NoTypeInformation -Append
        Load-AEMEnvs
        
    }
    
    end {
    }
}   

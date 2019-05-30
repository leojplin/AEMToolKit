
function Test-Page {

    [CmdletBinding()]
    param (
        # Server name to create the package on
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $ServerName,

        # Folder name to create the project in
        [Parameter(ValueFromPipeline)]
        [String]
        $Path

        
    )
    
    begin {
        
    }
    
    process {
    
        $server = $aemEnv | Where-Object -Property name -Value $ServerName -eq

        if ($server -eq $null) {
            Write-Error -Message "ServerName $ServerName is not found."
            return;
        }
        
        $headers = @{
            Authorization = Get-BasicAuthorizationValue -Username $server.username -Password $server.password;
            "User-Agent"  = "curling"
        }
        
        
        $headers = @{
            Authorization = $basicAuthValue;
            "User-Agent"  = "curling"
        }

        try {
            $url = $server.url
            $res = Invoke-WebRequest -Uri "$($url)$path.html" -Method Get -Headers $headers
            $True
        }
        catch {
            $false
        }
    }
    
    end {
    }
}   
function Get-PropertyAsJson {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $ServerName,

        [Parameter(ValueFromPipelineByPropertyName = $True)]
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
            Authorization  = Get-BasicAuthorizationValue -Username $server.username -Password $server.password;
            "Content-Type" = "application/x-www-form-urlencoded";
            "User-Agent"   = "curling"
        }
            
        try {
            $url = $server.url
            $res = Invoke-WebRequest -Uri "$url$Path" -Method Get -Headers $headers
            $json = ConvertFrom-Json $res.Content
            Write-Output $json
        }
        catch {
            "something wrong"
        }


    }
        
    end {
    }
}   

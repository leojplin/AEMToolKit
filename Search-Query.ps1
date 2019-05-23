function Search-Query {

    [CmdletBinding()]
    param (
        # Server name to create the package on
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $ServerName,

        # Folder name to create the project in
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $Statement

        
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
            "User-Agent"  = "curling"
        }
        
        $form = @{
            "_charset_"   = "utf-8"
            "type"        = "JCR-SQL2"
            "stmt"        = $Statement
            "showResults" = "true"
        }
        try {
            $url = $server.url
            $res = Invoke-WebRequest -Uri "$($url)/crx/de/query.jsp" -Method Get -Headers $headers -Body $form
            $($res.Content | ConvertFrom-Json).results | % { Write-Output $_.path }

        }
        catch {
            # throw $_.Exception
            Write-Error -Message "Query failed."
            return
        }
    }
    
    end {
    }
}   

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
        $pair = "$($server.user):$($server.password)"
        $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
        $url = $server.host
        $basicAuthValue = "Basic $encodedCreds"

        $headers = @{
            Authorization = $basicAuthValue;
            "User-Agent"  = "curling"
        }

        try {
            $res = Invoke-WebRequest -Uri "$($url)$path.html" -Method Get -Headers $headers
            return $True
        }
        catch {
            if ($_.Exception.Response.StatusCode -eq 'NotFound') {
                return $false
            }
            else {
                Write-Error -Message "Query failed."
            }

            return $false
        }
    }
    
    end {
    }
}   
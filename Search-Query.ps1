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
            Authorization = Get-BasicAuthorizationValue -Username $server.username -Password $server.password;
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
            $($res.Content | ConvertFrom-Json).results | % { 
                $obj = New-Object -TypeName psobject
                $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $ServerName
                $obj | Add-Member -MemberType NoteProperty -Name Path -Value $($_.path)
        
                Write-Output $obj 
            }

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

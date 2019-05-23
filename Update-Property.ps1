function Update-Property {
    [CmdletBinding()]
    param (
        # Server name to create the package on
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $ServerName,

        # Folder name to create the project in
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $Path,

        # Target language to translate to
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $Form
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
        
        $forms = @{ };
        $Form -split ',' | % {
            $prop, $val = $_ -split '='
            $forms.Add($prop, $val);
        }
        
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $ServerName
        $obj | Add-Member -MemberType NoteProperty -Name Path -Value $Path
        
        try {
            $url = $server.url
            $res = Invoke-WebRequest -Uri "$url$Path" -Method Post -Headers $headers -Body $forms
            $res.StatusCode
            $obj | Add-Member -MemberType NoteProperty -Name Updated -Value $True
        }
        catch {
            $obj | Add-Member -MemberType NoteProperty -Name Updated -Value $False
        }
        
        Write-Output $obj
    }
        
    end {
    }
}   

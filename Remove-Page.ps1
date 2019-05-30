function Remove-Page {

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
        
        $form = @{
            "_charset_"     = "utf-8"
            "cmd"           = "deletePage"
            "path"          = $Path
            "force"         = "true"
            "checkChildren" = "false"
        }
        
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $ServerName
        $obj | Add-Member -MemberType NoteProperty -Name Path -Value $Path

        try {
            $url = $server.url
            $res = Invoke-WebRequest -Uri "$url/bin/wcmcommand" -Method Post -Headers $headers -Body $form
            $obj | Add-Member -MemberType NoteProperty -Name Removed -Value $True
        }
        catch {
            $obj | Add-Member -MemberType NoteProperty -Name Removed -Value $false
        }
    }
    
    end {
    }
}   




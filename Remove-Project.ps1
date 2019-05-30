function Remove-Project {
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
        
        $form = @{
            "path"                             = $Path
            "removeGroups"                     = "true"
            "removeGroups@Delete"              = ""
            "deleteProjectAssetFolder"         = "true"
            "deleteProjectAssetFolder@Delete"  = "" 
            "terminateProjectWorkflows"        = "true"
            "terminateProjectWorkflows@Delete" = "" 
            "_charset_"                        = "utf-8"
            ":operation"                       = "projectdelete"
        }
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $ServerName
        $obj | Add-Member -MemberType NoteProperty -Name Path -Value $Path

        try {
            $url = $server.url
            $res = Invoke-WebRequest -Uri "$($url)/content/projects" -Method Post -Headers $headers -Body $form
            $obj | Add-Member -MemberType NoteProperty -Name Removed -Value $True
        }
        catch {
            $obj | Add-Member -MemberType NoteProperty -Name Removed -Value $false
        }
        Write-Output $obj
    }
    
    end {
    }
}   


function Remove-Project {
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
        try {
            $url = $server.url
            $res = Invoke-WebRequest -Uri "$($url)/content/projects" -Method Post -Headers $headers -Body $form
            $res.StatusCode
            Write-Information "$Path Removed."
            Write-Output $Path
        }
        catch {
            # throw $_.Exception
            Write-Error -Message "$Path removal failed."
            return
        }
    }
    
    end {
    }
}   


function Deactivate-Node {

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
            "_charset_" = "utf-8"
            "action"    = "replicatedelete"
            "path"      = $Path
        }
        
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $ServerName
        $obj | Add-Member -MemberType NoteProperty -Name Path -Value "$path"

        try {
            $url = $server.url
            $res = Invoke-WebRequest -Uri "$url/crx/de/replication.jsp" -Method Post -Headers $headers -Body $form
            $obj | Add-Member -MemberType NoteProperty -Name Deactivated -Value "True"
        }
        catch {
            $obj | Add-Member -MemberType NoteProperty -Name Deactivated -Value "False"
            $_
        }
        Write-Output $obj
    }
    
    end {
    }
}   




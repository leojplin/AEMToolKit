function New-LanguageCopy {
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

        # Folder name to create the project in
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $Deep,

        # Language to create language copy to
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $Language,

        # Language to create language copy to
        [Parameter(ValueFromPipelineByPropertyName = $True, Mandatory = $True)]
        [String]
        $SourceLanguage


        
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
            "_charset_"                     = "utf-8"
            ":status"                       = "browser"
            "payloadType"                   = "JCR_PATH"
            "model"                         = "/etc/workflow/models/wcm-translation/create_language_copy/jcr:content/model"
            "createNonEmptyAncestors"       = "true"
            "deep"                          = $Deep
            "payload"                       = $Path
            "projectFolderPath"             = "" 
            "projectFolderLanguageRefCount" = "1"
            "language"                      = $Language
            "projectTitle"                  = ""
            "projectType"                   = "add_structure_only"
            "workflowTitle"                 = "Copy Structure $Path"
        }

        $createdPath = $Path -replace $SourceLanguage, $Language
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $ServerName
        $obj | Add-Member -MemberType NoteProperty -Name Path -Value $createdPath

        try {
            $url = $server.url
            $res = Invoke-WebRequest -Uri "$($url)/etc/workflow/instances" -Method Post -Headers $headers -Body $form
    
            $obj | Add-Member -MemberType NoteProperty -Name Created -Value True
    

        }
        catch {
            # throw $_.Exception
            $obj | Add-Member -MemberType NoteProperty -Name Created -Value False
    
        }
        Write-Output $obj
    }
    
    end {
    }
}   



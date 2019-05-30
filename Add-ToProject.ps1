function Add-ToProject {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $ServerName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [String]
        $ProjectPath,

        [Alias("Path")]
        [Parameter(ValueFromPipelineByPropertyName)]
        [String]
        $PagePath
        
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
            ":translationJobPath" = "$ProjectPath/jcr:content/dashboard/gadgets/translationjob"
            "_charset_"           = "UTF-8"
            "createLanguageCopy"  = "false"
            ":operation"          = "ADD_TRANSLATION_PAGES"
            "translationpage"     = $PagePath
        }
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $ServerName
        $obj | Add-Member -MemberType NoteProperty -Name PagePath -Value $PagePath
        $obj | Add-Member -MemberType NoteProperty -Name ProjectPath -Value $ProjectPath


        try {
            $url = $server.url
            $res = Invoke-WebRequest -Uri "$($url)$ProjectPath/jcr:content/dashboard/gadgets/translationjob" -Method Post -Headers $headers -Body $form
            $obj | Add-Member -MemberType NoteProperty -Name Added -Value $True
        }
        catch {
            $obj | Add-Member -MemberType NoteProperty -Name Added -Value $false
        }
    }
    
    end {
    }
}   

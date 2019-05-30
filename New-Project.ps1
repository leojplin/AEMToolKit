function New-Project {
    [CmdletBinding()]
    param (
        # Server name to create the package on
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $ServerName,

        # Folder name to create the project in
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $FolderName,

        # Target language to translate to
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $TargetLanguage,

        # Project name
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $ProjectName,

        # Source language to translate from
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $SourceLanguage,

        # Translation Method
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $TranslationMethod,

        # Translation provider
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [string]
        $TranslationProvider,

        # Cloud config
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $CloudConfigPath,

        # Cloud config name
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $CloudConfigName,
            
        # Owners
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $Owners
            
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
            "Content-Type" = "multipart/form-data; boundary=----WebKitFormBoundary445UpSlzflHm4cxp";
            "User-Agent"   = "curling"
        }

        $OwnersSection = $($Owners -split ',' | % {

                Write-Output "Content-Disposition: form-data; name=`"teamMemberUserId`"

$_
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name=`"teamMemberRoleId`"

owner
------WebKitFormBoundary445UpSlzflHm4cxp
"
            })

        $form = @"
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name=":operation"

projectcreate
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="_charset_"

UTF-8
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="wizard"

/libs/cq/core/content/projects/wizard/translationproject/defaultproject.html
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="template"

/libs/cq/core/content/projects/templates/translation-project
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="templateorproject"

/libs/cq/core/content/projects/templates/translation-project
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="templateorproject@Delete"


------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="taskid"


------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="coverImage"; filename=""
Content-Type: application/octet-stream


------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="jcr:title"

$ProjectName
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="jcr:description"


------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="project.startDate"


------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="project.startDate@TypeHint"

Date
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="project.dueDate"


------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="project.dueDate@TypeHint"

Date
------WebKitFormBoundary445UpSlzflHm4cxp
${OwnersSection}Content-Disposition: form-data; name="parentPath"

/content/projects/$FolderName
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="name"

$ProjectName
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="sourceLanguage"

$SourceLanguage
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="destinationLanguage"

$TargetLanguage
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="translationMethod"

$TranslationMethod
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="translationProvider"

$TranslationProvider
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="contentCategory"

general
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="translationCloudConfigPath"

$CloudConfigPath
------WebKitFormBoundary445UpSlzflHm4cxp
Content-Disposition: form-data; name="translationCloudConfigName"

$CloudConfigName
------WebKitFormBoundary445UpSlzflHm4cxp--
"@

        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $ServerName
        $obj | Add-Member -MemberType NoteProperty -Name ProjectName -Value $createdPath
        
        try {
            $url = $server.url
            $res = Invoke-WebRequest -Uri "$($url)/content/projects" -Method Post -Headers $headers -Body $form
            $res.Content -match "href='(.*)'"
            $obj | Add-Member -MemberType NoteProperty -Name ProjectPath -Value $($Matches[2])
            $obj | Add-Member -MemberType NoteProperty -Name Created -Value $True
        }
        catch {
            $obj | Add-Member -MemberType NoteProperty -Name Created -Value $false
        }
    }
        
    end {
    }
}   

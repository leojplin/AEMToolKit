
function Get-ChildPage {

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $ServerName,

        [Parameter(ValueFromPipelineByPropertyName)]
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


        try {
            $url = $server.url
            $res = Invoke-WebRequest -Uri "$url$path.tidy.1.json" -Method Get -Headers $headers 
            $json = $res.Content | ConvertFrom-Json 
            $json | gm | Where-Object { $_.MemberType -eq "NoteProperty" } | Where-Object { $x = $_.Name; $json."$x"."jcr:primaryType" -eq "cq:Page" } | % {
                $obj = New-Object -TypeName psobject
                $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $ServerName
                $obj | Add-Member -MemberType NoteProperty -Name Path -Value "$path/$($_.Name)"
                Write-Output $obj
                
            }     

        }
        catch {
            
            Write-Error -Message "Query failed."
            return $false
        }
    }
    
    end {
    }
}   

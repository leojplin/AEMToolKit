function Move-Content {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $From,

        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $To,

        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $Path,

        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [String]
        $ToPath
    )
    
    begin {
        
    }
    
    process {
    
        $f = $aemEnv | Where-Object -Property name -Value $From -eq
        $t = $aemEnv | Where-Object -Property name -Value $To -eq
        if (($f -eq $null) -or ($t -eq $null)) {
            Write-Error -Message "Servers not not found."
            return;
        }
        $fcred = "$($f.username)" + ":" + "$($f.password)"
        $tcred = $($t.username) + ":" + "$($t.password)"
        $furl = $f.url.Substring($f.url.LastIndexOf('/') + 1);
        $turl = $t.url.Substring($t.url.LastIndexOf('/') + 1);
        if ($ToPath) {
            $command = "vlt rcp http://$fcred@$($furl)/crx/-/jcr:root$path  http://$tcred@$($turl)/crx/-/jcr:root$ToPath -u -r -b 100"
        }
        else {
            $command = "vlt rcp http://$fcred@$($frul)/crx/-/jcr:root$path  http://$tcred@$($turl)/crx/-/jcr:root$path -u -r -b 100"
        }
        iex $command
    }
    end {
    }
}   



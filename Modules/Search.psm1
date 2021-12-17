# Search WEB

function Get-SearchEngine {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $Keyword
    )

    $webData = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Web Data"
    $tempWebData = New-TemporaryFile
    Copy-Item $webData $tempWebData
    try {
        $q = 'select keyword, url from keywords where is_active = 1'
        Invoke-SqliteQuery $q -Database $tempWebData |
            Where-Object { -not $Keyword -or $_ -eq $Keyword }
    }
    finally {
        Remove-Item $tempWebData
    }
}

class SearchEngineKeyword : System.Management.Automation.IValidateSetValuesGenerator {
     [String[]] GetValidValues() {
        return (Get-SearchEngine | Select-Object -ExpandProperty keyword)
     }
 }

function Search-Web {
	[CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet([SearchEngineKeyword])]
        [string]
        $Engine,
        [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
        [string[]]
        $Terms
    )

    $url = Get-SearchEngine |
        Where-Object keyword -eq $Engine |
        Select-Object -ExpandProperty url

    $t = ($Terms | Join-String -Separator ' ')

    $url = $url -replace '/\{searchTerms\}',('/' + [System.Uri]::EscapeUriString($t)) `
        -replace '=\{searchTerms\}',('=' + [System.Uri]::EscapeDataString($t))

    Start-Process $url
}

New-Alias srweb Search-Web -Force

Export-ModuleMember -Function Search-Web, Get-SearchEngine
Export-ModuleMember -Alias srweb

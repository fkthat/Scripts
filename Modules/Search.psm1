#
# Search WEB
#

function Get-EdgeSearchEngine {
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
            Where-Object { -not $Keyword -or $_.keyword -eq $Keyword }
    }
    finally {
        Remove-Item $tempWebData
    }
}

function Search-Web {
	[CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true, ValueFromPipeline = $true)]
        [string[]]
        $Terms
    )

    $engines = Get-EdgeSearchEngine

    $url = $engines | `
        Where-Object keyword -eq $Terms[0] | `
        Select-Object -ExpandProperty url

    if($url) {
        $Terms = $Terms[1..($Terms.Length - 1)]
    }
    else {
        $url = $engines | `
            Where-Object keyword -eq 'b' | `
            Select-Object -ExpandProperty url
    }

    $t = ($Terms | Join-String -Separator ' ')
    $url = $url -replace '{searchTerms}',([System.Uri]::EscapeDataString($t))
    Start-Process $url
}

#
# Aliases
#

New-Alias srweb Search-Web -Force
#
# Search WEB
#

Class EdgeSearchEngines : System.Management.Automation.IValidateSetValuesGenerator {
    static $engines;

    [string[]] GetValidValues() {
        return [string[]]([EdgeSearchEngines]::GetAll() |
            Select-Object -ExpandProperty keyword)
    }

    static [psobject[]] GetAll() {
        if(-not [EdgeSearchEngines]::engines) {
            $webData = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Web Data"
            $tempWebData = New-TemporaryFile
            Copy-Item $webData $tempWebData
            try {
                $q = 'select keyword, url from keywords where is_active = 1'
                [EdgeSearchEngines]::engines = `
                    Invoke-SqliteQuery $q -Database $tempWebData
            }
            finally {
                Remove-Item $tempWebData
            }
        }

        return [EdgeSearchEngines]::engines
    }
}
function Get-EdgeSearchEngine {
    [EdgeSearchEngines]::GetAll()
}

function Search-Web {
	[CmdletBinding()]
    param (
        # Search engine keyword. Default to 'b' (Bing).
        [Parameter(Position = 0)]
        [ValidateSet([EdgeSearchEngines])]
        $Engine = 'b',

        [Parameter(ValueFromRemainingArguments = $true, ValueFromPipeline = $true)]
        [string[]]
        $Terms
    )

    $t = ($Terms | Join-String -Separator ' ')

    $url = ([EdgeSearchEngines]::GetAll() |
        Where-Object keyword -eq $Engine |
        Select-Object -ExpandProperty url)

    $url = $url -replace `
        '{searchTerms}', ([System.Uri]::EscapeDataString($t))

    Start-Process $url
}

New-Alias srweb Search-Web -Force

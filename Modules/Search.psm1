function Open-Search {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string[]] $Terms,
        [Parameter(Mandatory = $true)]
        [string] $UrlFormat
    )

    $Query = $Terms | Join-String -Separator ' '
    $Query = [System.Uri]::EscapeDataString($Query)
    $Url = [System.String]::Format($UrlFormat, $Query)
    Start-Process $Url
}

function Search-Bing {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromRemainingArguments)]
        [string[]] $Terms
    )

    Open-Search $Terms -UrlFormat `
        "https://www.bing.com/search?q={0}"
}

function Search-Api {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromRemainingArguments)]
        [string[]] $Terms
    )

    Open-Search $Terms -UrlFormat `
        "https://docs.microsoft.com/en-us/dotnet/api/?term={0}"
}

function Search-Docs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromRemainingArguments)]
        [string[]] $Terms
    )

    Open-Search $Terms -UrlFormat `
        "https://docs.microsoft.com/en-us/search/?terms={0}"
}

function Search-Mdn {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromRemainingArguments)]
        [string[]] $Terms
    )

    Open-Search $Terms -UrlFormat `
        "https://developer.mozilla.org/en-US/search?q={0}"
}

function Search-WikiRu {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromRemainingArguments)]
        [string[]] $Terms
    )

    Open-Search $Terms -UrlFormat `
        "https://ru.wikipedia.org/w/index.php?search={0}"
}

function Search-WikiEn {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromRemainingArguments)]
        [string[]] $Terms
    )

    Open-Search $Terms -UrlFormat `
        "https://en.wikipedia.org/w/index.php?search={0}"
}

function Search-Cald {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromRemainingArguments)]
        [string[]] $Terms
    )

    Open-Search $Terms -UrlFormat `
        "https://dictionary.cambridge.org/dictionary/english/{0}"
}

function Search-WikiVim {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromRemainingArguments)]
        [string[]] $Terms
    )

    Open-Search $Terms -UrlFormat `
        "https://vim.fandom.com/wiki/Special:Search?search=%s"
}


New-Alias srbing Search-Bing -Force
New-Alias srapi Search-Api -Force
New-Alias srdocs Search-docs -Force
New-Alias srmdn Search-Mdn -Force
New-Alias srwikiru Search-WikiRu -Force
New-Alias srwikien Search-WikiEn -Force
New-Alias srcald Search-Cald -Force
New-Alias srwikivim Search-WikiVim -Force

Export-ModuleMember 'Search-Bing', 'Search-Api', 'Search-Docs', 
    'Search-Mdn', 'Search-WikiRu', 'Search-WikiEn', 'Search-Cald',
    'Search-WikiVim'

Export-ModuleMember -Alias 'srbing', 'srapi', 'srdocs',
    'srmdn', 'srwikiru', 'srwikien', 'srcald',
    'srwikivim'


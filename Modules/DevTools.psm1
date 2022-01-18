#
# Development tools.
#

<#
.SYNOPSIS
Starts Visual Studio 2022.
.DESCRIPTION
Starts instance(s) of Visual Studio 2022 and opens the specified solutions or
the solutions in the specified folders. If no paths provided then the current
folder is used.
#>
function Start-VisualStudio {
    param(
        # Path to the solution or folder.
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [string[]]
        $Path = '.')

    begin {
        $vs = "${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
    }

    process {
        $Path |
            Get-ChildItem -Filter *.sln  |
            Select-Object -Unique |
            Where-Object Extension -eq '.sln' |
            ForEach-Object { & $vs $_ }
    }
}

New-Alias vs Start-VisualStudio

<#
.SYNOPSIS
Starts VSCode.
.DESCRIPTION
Starts instance(s) of VSCode and opens the specified files or folders. If no
paths provided then the current folder is used.
#>
function Start-VSCode {
    param(
        # Path to the file or folder.
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [string[]]
        $Path = '.')

    begin {
        $code = "${env:LocalAppData}\Programs\Microsoft VS Code\bin\code.cmd"
    }

    process {
        $Path |
            Get-Item |
            Select-Object -Unique |
            ForEach-Object { & $code $_ -n }
    }
}

New-Alias code Start-VSCode

<#
.SYNOPSIS
Returns random test data from hit.ori.one.
#>
function Get-TestData {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateSet(
            'FirstName', 'LastName', 'Patronymic', 'DateOfBirth', 'Gender',
            'Company', 'Vacancy', 'BankName', 'BankCard', 'BankExp',
            'BankCVC', 'Login', 'Password', 'DocINN', 'DocSNILS', 'Address',
            'City', 'Street', 'House', 'Apartment', 'Phone', 'Email',
            'Website', 'CarBrand', 'CarModel', 'CarYear', 'CarColor', 'CarNum'
        )]
        [string[]]
        $Fields = @(),
        [Parameter(Mandatory = $false)]
        [ValidateSet('male', 'female', 'random')]
        $Gender = 'random',
        [Parameter(Mandatory = $false)]
        [int]
        $Count = 1
    )

    $url = 'https://hit.ori.one/api'

    $token =  `
        '01000000d08c9ddf0115d1118c7a00c04fc297eb01000000c393705e3ec62346aa1db1ce6b43cce2' + `
        '00000000020000000000106600000001000020000000d30beabdddb8117c8d58dec8c1a5c8fb5fa4' + `
        '2b86c228e3042579f0685f6a241d000000000e80000000020000200000006fc9323012cf0fa777ba' + `
        '39745142b0ed904f3950863b9f4f575b2a1cf46d3c8250000000f39a364302cd02671845fac7e6c9' + `
        'f05abb51a93c990d33827282b8e435af17bcb5ae0a0d2762471c77351b98db3717cb51d63761d67a' + `
        '86857c3e4d12ebd772240077be8915812387cdc43356213203f6400000002a8c1d3037958258d627' + `
        'f64ecd3ae0a0ffd41694fce5b986dd61ea1227fb18be2284a1dce91db09efecde08ef1727603c662' + `
        '014e98ab021434d88e3702d3749c' |
        ConvertTo-SecureString | ConvertFrom-SecureString -AsPlainText

    # Below looks strange but there're strange things on the server side happen...

    $body = @{
        token = $token;
        gender = $Gender;
        count = $Count;
        param = $Fields
    } | ConvertTo-Json

    $f = New-TemporaryFile
    Invoke-RestMethod -Uri $url -Method Post -Body $body -OutFile $f
    Get-Content $f | ConvertFrom-Json
    Remove-Item $f
}

<#
.SYNOPSIS
Returns a random datetime in the specified format.
#>
function Get-RandomDateTime {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [datetime]
        $Min = [datetime]::MinValue,
        [Parameter(Position = 1, Mandatory = $false)]
        [datetime]
        $Max = [datetime]::MaxValue,
        [Parameter(Mandatory = $false)]
        [ValidateSet('none', 'json', 'csharp')]
        $Format = 'none'
    )

    $dt = New-Object datetime ([Random]::Shared.NextInt64($Min.Ticks, $Max.Ticks))

    switch($Format) {
        'none' {
            $dt
        }
        'json' {
            (ConvertTo-Json $dt).Trim('"')
        }
        'csharp' {
            [string]::Format("new DateTime({0:yyyy, MM, dd, hh, mm, ss})", $dt)
        }
    }
}

<# function Get-GitDirtyFiles {
    git ls-files -o --exclude-standard
    git diff-index --name-only HEAD
} #>

<#
.SYNOPSIS
Returns a random temporary path.
.OUTPUTS
[string]
#>
function Get-TemporaryPath {
    Join-Path ([System.IO.Path]::GetTempPath()) `
        ([System.IO.Path]::GetRandomFileName())
}

<#
.SYNOPSIS
Creates a code coverage report.
.DESCRIPTION
Creates a new HTML code coverage report and returns the path to the HTML
report file.
.OUTPUTS
[string]
The path to the HTML file of the report.
#>
function New-CoverageReport {
    [CmdletBinding()]
    param (
        # The path or glob to the report file. Default to **\coverage.*
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [string[]]
        $Path = '**\coverage.*',
        # Output folder. Default to the generated temporary folder.
        [Parameter(Mandatory = $false)]
        [string]
        $OutDir = (Get-TemporaryPath)
    )

    process {
        $reports = Join-String -InputObject $Path -Separator ';'
        $log = reportgenerator -reports:$reports -targetdir:$OutDir

        if($?) {
            Join-Path $OutDir 'index.html'
        }
        else {
            Write-Host $log
        }
    }
}

New-Alias cover New-CoverageReport

function Start-Flow {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateSet('feature', 'fix')]
        $Prefix = 'feature',
        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $Name,
        [Parameter()]
        [switch]
        $UpdateMain
    )

    $throw = { Throw }

    if($UpdateMain) {
        if((git branch --show-current || &$throw) -eq 'develop') {
            git pull || &$throw
        }
        else {
            git fetch origin develop:develop || &$throw
        }
    }

    git checkout develop -b "$Prefix/$Name" &&
        git push -u origin "$Prefix/$Name"
}

New-Alias saflow Start-Flow -Force

function Invoke-DotNetBuild {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateSet('clean', 'restore', 'build', 'test')]
        $Target = 'build',
        [Parameter()]
        [ValidateSet('Debug', 'Release')]
        $Config = 'Debug'
    )

    switch($Target) {
        'clean' {
            git clean -dfX -e '!.vs' -e '!*.suo' -e '.vscode/*'
        }
        'restore' {
            dotnet restore
        }
        'build' {
            dotnet build -c $Config
        }
        'test' {
            dotnet test -c $Config -l 'trx;LogFileName=testlog.trx'
        }
    }
}

New-Alias build Invoke-DotNetBuild -Force

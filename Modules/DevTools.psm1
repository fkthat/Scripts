# Quick delete node_modules

function Remove-NodeModules {
    Get-ChildItem . -Recurse -Filter node_modules |
        Remove-Item -Recurse -Force
}

# Git tools

function Clear-Git {
    Remove-NodeModules
    git clean -dfx -e .vs -e .vscode
}

function Start-VisualStudio {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string[]]
        $Path)

    begin {
        $vs = "${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"

        if(-not $Path) {
            $Path = (Get-ChildItem -Filter *.sln)
        }
    }

    process {
        $Path | ForEach-Object { & $vs $_ }
    }
}

function Start-VSCode {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string[]]
        $Path = '.')

    begin {
        $code = "${env:LocalAppData}\Programs\Microsoft VS Code\bin\code.cmd"
    }

    process {
        & $code $Path -n
    }
}

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

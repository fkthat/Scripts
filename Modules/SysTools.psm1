# Disk size and free space info

function Get-DiskInfo {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)] [string] $DiskId
    )

    begin {
        $size = @{ label = 'Size'; expression = { [Math]::Round($_.Size / 1GB, 1) } }
        $free = @{ label = 'FreeSpace'; expression = { [Math]::Round($_.FreeSpace / 1GB, 1) } }
    }

    process {
        Get-CimInstance Win32_LogicalDisk `
            -Filter "DeviceID='${DiskId}'" |
            Select-Object DeviceId,$size,$free
    }
}

# Links

function New-ItemLink {
	[CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true)] [string] $Target,
        [Parameter(Position = 1, Mandatory = $false)] [string] $Path,
        [switch] $Hard,
        [switch] $Force
    )

    if(-not (Test-Path $Target)) {
        Write-Error "$Target does''n exist."
        return
    }

    if(-not $Path) {
        $Path = (Split-Path $Target -Leaf)
    }

    $targetItem = Get-Item $Target

    if($targetItem.PSIsContainer -and $Hard) {
        Write-Error 'Cannot hardlink a folder.'
        return
    }

    if($Hard) {
        New-Item -ItemType HardLink -Target $Target -Path $Path -Force:$Force
    }
    else {
        New-Item -ItemType SymbolicLink -Target $Target -Path $Path -Force:$Force
    }
}

# Touch file

function Set-ItemDateTime {
	[CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [string] $Path
    )

    process {
        if(Test-Path $Path) {
            Set-ItemProperty $Path -Name LastWriteTime  -Value (Get-Date)
        }
        else {
            New-Item $Path -ItemType File
        }
    }
}

function Get-Diff {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]
        $Path1,
        [Parameter(Position = 1, Mandatory = $true)]
        [string]
        $Path2
    )

    & "${env:ProgramFiles}\Git\usr\bin\diff.exe" -rcs --color=always $Path1 $Path2
}

# Edit etc/hosts file

function Edit-Hosts {
    vi "${env:SystemRoot}\System32\drivers\etc\hosts"
}

# Start Windows Terminal as administrator

function Start-AdminTerminal {
    [CmdletBinding()]
    $term = 'shell:appsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App'
    Start-Process $term -Verb RunAs
}

# 'sed'

function sed {
    [CmdletBinding()]
     param (
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [string[]]
        $Path,
        [Parameter(Mandatory = $true)]
        [string]
        $Pattern,
        [Parameter(Mandatory = $true)]
        [string]
        $Replace
     )

     process {
        $Path |
            ForEach-Object {
                $file = $_

                $s = Get-Content $file |
                    ForEach-Object {
                        $_ -replace $Pattern, $Replace
                    } | Join-String -Separator ([System.Environment]::NewLine)

                $s > $file
            }
     }
}

function Set-EnvironmentVariable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [object]
        $Value,

        [Parameter(Mandatory = $false)]
        [Microsoft.Win32.RegistryValueKind]
        $Type = [Microsoft.Win32.RegistryValueKind]::String,

        [Parameter(Mandatory = $false)]
        [ValidateSet('User', 'Machine')]
        $Scope = 'User'
    )

    switch ($Scope) {
        'User' { $reg = 'HKCU:\Environment' }
        'Machine' { $reg = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'}
        Default {}
    }

    Set-ItemProperty $reg -Name $Name -Value $Value
}

function Remove-EnvironmentVariable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [ValidateSet('User', 'Machine')]
        $Scope = 'User'
    )

    switch ($Scope) {
        'User' { $reg = 'HKCU:\Environment' }
        'Machine' { $reg = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' }
        Default {}
    }

    if($null -ne (Get-Item $reg).GetValue($Name)) {
        Remove-ItemProperty $reg -Name $Name
    }
}

function Reset-EnvironmentVariables {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('user', 'machine')]
        $Scope = 'user'
    )

    Set-EnvironmentVariable 'PATH' `
        -Value '%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem' `
        -Scope Machine

    Remove-EnvironmentVariable 'PATH' -Scope User
}

function New-DevelopmentCertificates {
    $ca = 'FkThat Development CA'
    $domain = 'home.arpa'

    $password =
    '01000000d08c9ddf0115d1118c7a00c04fc297eb01000000ba083c6a0e76564d874416c8fc43731c00' +
    '000000020000000000106600000001000020000000d6270abe28ca84a2d45a4d571090ba349432b842' +
    '7a8b631b9f6c52779b8073ca000000000e8000000002000020000000f9a4eb15f682aefb43dacc67' +
    '147ba50530259f64f695c120fcffb99d8fc9a7ab20000000701f48215ce2b84c7f7f2cc607f7b9c7' +
    'd7595b85e84409e81115c91bf762c69e4000000099923a60670c2f3c9cb8ca8b5f3510d008d34fd1' +
    '9fff81328b3903edaf0da7763fb454d9667fefc25c5aefce443c54ee1965b12504e17283c87a2b798f67eb31'

    $caCert = New-SelfSignedCertificate `
        -DnsName $ca `
        -KeyLength 2048 `
        -KeyAlgorithm 'RSA' `
        -HashAlgorithm 'SHA256' `
        -KeyExportPolicy 'Exportable' `
        -NotAfter (Get-Date).AddYears(5) `
        -CertStoreLocation 'Cert:\CurrentUser\My' `
        -KeyUsage 'CertSign', 'CRLSign'

    $cert = New-SelfSignedCertificate `
        -DnsName "*.$domain" `
        -Signer $caCert `
        -KeyLength 2048 `
        -KeyAlgorithm 'RSA' `
        -HashAlgorithm 'SHA256' `
        -KeyExportPolicy 'Exportable' `
        -NotAfter (Get-date).AddYears(2) `
        -CertStoreLocation 'Cert:\CurrentUser\My'

    $caCrtFile = ($ca -replace '\s+', '_') + '.crt'
    Export-Certificate -Cert $caCert -FilePath $caCrtFile -Force | Out-Null
    Import-Certificate -CertStoreLocation 'Cert:\CurrentUser\Root' -FilePath $caCrtFile
    $secure = (ConvertTo-SecureString $password)
    Export-PfxCertificate $cert "${domain}.pfx" -Password $secure -Force | Out-Null
}

# aliases
New-Alias gdiff Get-Diff -Force
New-Alias ln New-ItemLink -Force
New-Alias touch Set-ItemDateTime -Force
New-Alias su Start-AdminTerminal -Force
New-Alias gdi Get-DiskInfo -Force

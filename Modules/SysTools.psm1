# Disk size and free space info

<#
.SYNOPSIS
Returns disk usage info.
#>
function Get-DiskInfo {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string[]] $DiskId
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
        [string] $Path,
        [Parameter()]
        [switch]
        $Force
    )

    process {
        if(Test-Path $Path) {
            Set-ItemProperty $Path -Name LastWriteTime -Value (Get-Date)
        }
        else {
            New-Item $Path -ItemType File -Force:$Force
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

#
# Open etc/hosts file in vi editor
#

function Edit-Hosts {
    vi "${env:SystemRoot}\System32\drivers\etc\hosts"
}

# Start Windows Terminal as administrator

function Start-AdminTerminal {
    [CmdletBinding()]
    $term = 'shell:appsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App'
    Start-Process $term -Verb RunAs
}

#
# Environment tools
#

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

    Set-ItemProperty $reg -Name $Name -Value $Value -Type $Type
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

function Test-ElevatedUser {
    if($PSVersionTable.Platform -eq 'Win32NT') {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal $identity
        Write-Output $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    }
}

function Reset-Path {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('user', 'machine')]
        $Scope = 'user'
    )

    Set-EnvironmentVariable 'PATH' `
        -Value '%ProgramFiles%\dotnet;%ProgramFiles%\Git\bin;%USERPROFILE%\.dotnet\tools' `
        -Scope User -Type ExpandString

    if(Test-ElevatedUser) {
        Set-EnvironmentVariable 'PATH' `
            -Value '%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem' `
            -Scope Machine -Type ExpandString
    }
}

#
# Creates self-signed certificates for development
#

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

function Reset-WinTray {
    Remove-ItemProperty `
        'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify\' `
        -Name 'IconStreams','PastIconsStream'
}

function Split-Text {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        $Text,
        [Parameter(Mandatory = $false, Position = 1)]
        [int]
        $MaxLength = 80
    )

    process {
        0..($Text.Length / $MaxLength) |
            ForEach-Object {
                $i = $_ * $MaxLength
                $Text.Substring($i, [Math]::Min($Text.Length - $i, $MaxLength))
            }
    }
}

function Edit-FileContent {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $Path,
        [Parameter(Position = 1, Mandatory = $true)]
        [scriptblock]
        $Process,
        [Parameter(Mandatory = $false)]
        [scriptblock]
        $Begin = {},
        [Parameter(Mandatory = $false)]
        [scriptblock]
        $End = {}
    )

    process {
        $Path | ForEach-Object {
            $tmp = New-TemporaryFile
            Get-Content $_ |
                ForEach-Object -Begin $Begin -Process $Process -End $End |
                Out-File $tmp
            Copy-Item $tmp $_
            Remove-Item $tmp
        }
    }
}

<#
.SYNOPSIS
Publish an image from the clipboard to the imgbb.com server.
Returns the link to the newly published image.
#>
function Publish-BB {
    [CmdletBinding()]
    param (
        # Resize the image to this percentage. Default is 50.
        [Parameter()]
        [int]
        $Scale = 50 # to 50% (i.e. 2 as smaller)
    )

    $dll = "${env:ProgramFiles}\dotnet\shared\Microsoft.WindowsDesktop.App\3.1.14\System.Windows.Forms.dll"
    [System.Reflection.Assembly]::LoadFrom($dll) | Out-Null

    $ApiKey = `
        '01000000d08c9ddf0115d1118c7a00c04fc297eb01000000e4b16b938aa09249a4cb328c9969b496' +
        '000000000200000000001066000000010000200000008aac97451a45bb62bc6ff9767ada4682e3ee' +
        'a66aba7c3a71b50151267c138839000000000e8000000002000020000000445d4ceb76f1080f7426' +
        '40d088cc7702623df81a5a7e8f9c34933d7888f08cc550000000ed4f9ee60ca362e89d5f3d5ff10f' +
        '35e0d9c60e8e9dfe8e99648afc2064daaeba5b9e456727d501b95ee4d1ddbb881424b7170acf49e5' +
        '44bdb102ef75d28ce9ba9d644ecb557ed5a160b39c8ea12ee87440000000299cd00f1d1ae9bda5a3' +
        'ec9a225859d093eca16146b100d7297d81f6bf1db078c44e815ba8876bdadd779232863fe9a52c82' +
        'd4ea03c366eb93269dc344276317'

    $secret = ConvertTo-SecureString $ApiKey
    $secret = ConvertFrom-SecureString $secret -AsPlainText
    $Url = "https://api.imgbb.com/1/upload?key=$secret"

    $Img = [System.Windows.Forms.Clipboard]::GetImage()

    if ($Img) {
        try {
            [int] $W = $Img.Width * $Scale / 100
            [int] $H = $Img.Height * $Scale / 100
            $Scaled = New-Object 'System.Drawing.Bitmap' $Img, $W, $H

            try {
                $Buf = New-Object 'System.IO.MemoryStream'
                $Scaled.Save($Buf, [System.Drawing.Imaging.ImageFormat]::Png)
                $B64 = [System.Convert]::ToBase64String($Buf.ToArray())

                $Json = Invoke-WebRequest $Url -Method POST -Form @{ image = $B64 } |
                ConvertFrom-Json

                Write-Output $Json.data.url
            }
            finally {
                $Scaled.Dispose()
            }
        }
        finally {
            $Img.Dispose()
        }
    }
}

New-Alias gdiff Get-Diff -Force
New-Alias ln New-ItemLink -Force
New-Alias su Start-AdminTerminal -Force
New-Alias touch Set-ItemDateTime -Force
New-Alias sed Edit-FileContent -Force
New-Alias pbimg Publish-BB -Force
New-Alias gdi Get-DiskInfo -Force


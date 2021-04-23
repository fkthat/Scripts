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

function Start-Admin {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]
        $FilePath = 'shell:appsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App',

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]
        $ArgumentList
    )
    Start-Process $FilePath -ArgumentList $ArgumentList  -Verb RunAs
}

# aliases
New-Alias gdiff Get-Diff
New-Alias ln New-ItemLink
New-Alias touch Set-ItemDateTime
New-Alias sudo Start-Admin

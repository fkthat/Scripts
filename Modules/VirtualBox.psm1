# VirtualBox

$vbman = "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe"

function Get-VM {
    $rex = '"(.*)"\s+(\{[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}\})$'

    $running = (& $vbman list runningvms | ForEach-Object {
        if ($_ -match $rex) {
            $matches[2]
        }
    })

    & $vbman list vms | ForEach-Object {
        if ($_ -match $rex) {
            Write-Output ([PSCustomObject]@{
                Id      = New-Object System.Guid $matches[2];
                Name    = $matches[1];
                Running = ($running -contains $matches[2])
            })
        }
    }
}

function Start-VM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true)]
        [ArgumentCompleter({
            param ($x, $y, $w)
            Get-VM | Where-Object { -not $_.Running -and $_.Name -like "$w*" } |
            Select-Object -ExpandProperty Name
        })]
        [string[]]
        $Name
    )

    process {
        if(-not $Name) {
            $Name = Get-VM | Where-Object -not Running |
                Select-Object -ExpandProperty Name
        }

        $Name | ForEach-Object {
            & $vbman startvm $Name -type $guiType
        }
    }
}

function Stop-VM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true)]
        [ArgumentCompleter({
            param ($x, $y, $w)
            Get-VM | Where-Object { $_.Running -eq $true -and $_.Name -like "$w*" } |
            Select-Object -ExpandProperty Name
        })]
        [string[]]
        $Name
    )

    process {
        if(-not $Name) {
            $Name = Get-VM | Where-Object Running |
                Select-Object -ExpandProperty Name
        }

        $Name | ForEach-Object {
            & $vbman controlvm $_ acpipowerbutton
        }
    }
}

function New-VMSnaphot {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string] $Name
    )

    $timestamp = [datetime]::Now.ToString('yyyy/MM/dd HH:mm:ss')
    $snapshot = "$($Name): $timestamp"
    & $vbman snapshot $Name take $snapshot
}

function Compress-VMDisk {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string[]] $Path
    )

    process {
        $Path | Foreach-Object {
            if (Test-Path $_ -PathType Leaf) {
                & $vbman modifymedium disk $_ -compact
            }
        }
    }
}

Set-Alias vbman  "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe"
Set-Alias gvm Get-VM
Set-Alias savm Start-VM
Set-Alias spvm Stop-VM

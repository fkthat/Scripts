# VirtualBox

$vbman = "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe"

function Get-VM {
    $rex = '"(.*)"\s+(\{[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}\})$'

    $running = (vbman list runningvms | ForEach-Object {
       if($_ -match $rex) {
            $matches[2]
       }
    })

    vbman list vms | ForEach-Object {
       if($_ -match $rex) {
            [PSCustomObject]@{
                Id = $matches[2];
                Name = $matches[1];
                Running = ($running -contains $matches[2])
            }
       }
    }
}

function Start-VM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [ArgumentCompleter({
            param ($x, $y, $w)
            Get-VM | Where-Object { $_.Running -eq $false -and $_.Name -like "$w*" } |
                Select-Object -ExpandProperty Name
        })]
        [string] $Name,
        [Parameter(Mandatory = $false)]
        [ValidateSet('headless', 'gui')]
        [string] $Gui = 'headless'
    )

    process {
        & $vbman startvm $Name -type $Gui
    }
}

function Stop-VM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [ArgumentCompleter({
            param ($x, $y, $w)
            Get-VM | Where-Object { $_.Running -eq $true -and $_.Name -like "$w*" } |
                Select-Object -ExpandProperty Name
        })]
        [string] $Name
    )
    process {
        & $vbman controlvm $Name acpipowerbutton
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
        [string] $Path
    )
    process {
        if(Test-Path $Path -PathType Leaf) {
           & $vbman modifymedium disk $Path -compact
        }
    }
}

New-Alias vbman "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe" -Force
New-Alias gvm Get-VM -Force
New-Alias savm Start-VM -Force
New-Alias spvm Stop-VM -Force

#
# Custom PowerShell Prompt
#

function Test-Elevated() {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal $identity
    Write-Output $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Prompt {
    $esc = [char]27;

    $cp = (Get-Location).Path

    if ($cp.StartsWith($HOME)) {
        $cp = '~' + $cp.Substring($HOME.Length)
    }

    if( $cp -ne '~') {
        $host.UI.RawUI.WindowTitle = $cp | Split-Path -Leaf
    }
    else {
        $host.UI.RawUI.WindowTitle = $cp
    }

    if(Test-Elevated) {
        $user = "$esc[31mADMIN@$env:COMPUTERNAME"
    } else {
        $user ="$esc[92m$env:USERNAME@$env:COMPUTERNAME"
    }

    return "PS ${user}:$esc[34m$cp$esc[37m`$ "
}

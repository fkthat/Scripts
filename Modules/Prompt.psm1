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

    $prompt = "PS "

    $ComputerName = [System.Environment]::MachineName
    $UserName = [System.Environment]::UserName

    if($PSVersionTable -eq "Win32NT" -and (Test-Elevated)) {
        $prompt += "$esc[31m"
        $Tail = '#'
    } else {
        $prompt += "$esc[92m"
        $Tail = '$'
    }

    $prompt +=  "$UserName@${ComputerName}:$esc[34m$cp$esc[37m$Tail "

    if($env:TERM_PROGRAM -ne "vscode") {
        $prompt += "$esc[5 q"
    }

    return $prompt
}

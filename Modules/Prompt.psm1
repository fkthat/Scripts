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

    if(Test-Elevated) {
        $prompt += "$esc[31mADMIN@$env:COMPUTERNAME"
    } else {
        $prompt += "$esc[92m$env:USERNAME@$env:COMPUTERNAME"
    }

    $prompt +=  ":$esc[34m$cp$esc[37m`$ "

    if( $env:TERM_PROGRAM -ne "vscode") {
        $prompt += "$esc[5 q"
    }

    return "$prompt"
}

#
# Custom PowerShell Prompt
#

function Test-Elevated() {
    if($PSVersionTable.Platform -eq 'Win32NT') {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal $identity
        Write-Output $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    }
}

function Get-TerminalColorString(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('white', 'green', 'blue', 'red')]
    $Color
) {
    switch ($Color) {
        'white' { "`e[37m" }
        'green' { "`e[32m" }
        'blue' { "`e[34m" }
        'red' { "`e[31m" }
    }
}

function Get-PromptPath {
    $h = [regex]::Escape($HOME)
    $s = [regex]::Escape([System.IO.Path]::DirectorySeparatorChar)
    (Get-Location).Path -replace "^${h}(?<tail>${s}.*)?",'~${tail}'
}

function Get-TerminalTitle {
    Get-PromptPath
}

function Get-PromptUserInfo  {
    "$([System.Environment]::UserName)@$([System.Environment]::MachineName)"
}

function Get-PromptUserInfoColorString {
     Get-TerminalColorString ((Test-Elevated) ? "red" : "green")
}

function Get-PromptSuffix {
    (Test-Elevated) ? "#" : "$"
}

function  Get-ResetCursorString {
    $env:TERM_PROGRAM -ne "vscode" ? "`e[5 q" : ""
}

function Prompt {
    $host.UI.RawUI.WindowTitle = Get-TerminalTitle

    "$(Get-TerminalColorString "white")PS " + `
    "$(Get-PromptUserInfoColorString)$(Get-PromptUserInfo)" + `
    "$(Get-TerminalColorString "white"):" + `
    "$(Get-TerminalColorString "blue")$(Get-PromptPath)" +`
    "$(Get-TerminalColorString "white")$(Get-PromptSuffix) " + `
    "$(Get-ResetCursorString)"
}

Export-ModuleMember -Function "Prompt"

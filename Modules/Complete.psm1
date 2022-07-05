
#
# WinGet
#

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

#
# GitHub CLI
#

$gh = "$env:ProgramFiles\GitHub CLI\gh.exe"

if(Test-Path $gh) { 
    Invoke-Expression -Command $(& $gh completion -s powershell | Out-String)
}

#
# Dotnet CLI
# https://docs.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete#powershell
#

Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

#
# Installed completion modules
#

Import-Module posh-git


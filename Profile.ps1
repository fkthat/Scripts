#
# PowerShell profile script
#

# This sould be before posh-git loading
New-Alias git "${env:ProgramFiles}\Git\bin\git.exe" -Force
Import-Module posh-git
Import-Module DockerCompletion

# custom modules
Get-ChildItem "$PSScriptRoot\Modules" -Filter *.psm1 |
    Select-Object -ExpandProperty FullName |
    Import-Module

# PSReadLine settings
Set-PSReadLineOption -EditMode vi

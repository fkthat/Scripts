#
# PowerShell profile script
#

Import-Module posh-git
Import-Module DockerCompletion

# custom modules
Get-ChildItem "$PSScriptRoot\Modules" -Filter *.psm1 |
    Select-Object -ExpandProperty FullName |
    Import-Module

# PSReadLine settings
Set-PSReadLineOption -EditMode vi

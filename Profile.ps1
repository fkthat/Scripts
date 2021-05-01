#
# PowerShell profile script
#

# posh-git should be loaded manually
Import-Module posh-git

# custom modules
Get-ChildItem "$PSScriptRoot\Modules" -Filter *.psm1 |
    Select-Object -ExpandProperty FullName |
    Import-Module

# PSReadLine settings
Set-PSReadLineOption -EditMode vi

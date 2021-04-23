#
# PowerShell profile script
#

# posh-git should be loaded manually
Import-Module posh-git

# custom modules
Get-Item $PROFILE |
    ForEach-Object { $_.Target ?? $_ } |
    Split-Path -Parent |
    Join-Path -ChildPath "Modules" |
    Get-ChildItem  -Filter *.psm1 |
    Select-Object -ExpandProperty FullName |
    Import-Module

# PSReadLine settings
Set-PSReadLineOption -EditMode vi


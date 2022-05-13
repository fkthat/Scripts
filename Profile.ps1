#
# PowerShell profile script
#

# custom modules
Get-ChildItem "~\Scripts\Modules" -Filter *.psm1 |
    Select-Object -ExpandProperty FullName |
    Import-Module

# PSReadLine settings
Set-PSReadLineOption -EditMode vi

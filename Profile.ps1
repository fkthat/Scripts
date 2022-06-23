#
# PowerShell profile script
#

# custom modules
Get-ChildItem "~\Scripts\Modules" -Filter *.psm1 | Import-Module

# PSReadLine settings
Set-PSReadLineOption -EditMode vi

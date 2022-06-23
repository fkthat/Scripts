
Push-Location $PSScriptRoot

git checkout develop && git pull

# reload modules
Get-ChildItem -Filter *.psm1 |
    Select-Object -ExpandProperty FullName |
    Import-Module -Force

Pop-Location

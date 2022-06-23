
Push-Location $PSScriptRoot

git checkout develop && git pull

# reload modules
Get-ChildItem -Filter *.psm1 | Import-Module -Force

Pop-Location

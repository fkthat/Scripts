#
# Run it before invoking docker-compose on the Windows
#

Get-ChildItem $PSScriptRoot -Recurse -File -Exclude .gitignore,*.ps1 |
    ForEach-Object {
        $text = (Get-Content $_ -Raw) -replace "`r`n","`n" -replace "\s*$",""
        $text > $_
    }

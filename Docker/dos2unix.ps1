Get-ChildItem $PSScriptRoot -Recurse -File -Exclude .gitignore,*.ps1 |
    ForEach-Object {
        $text = (Get-Content $_ -Raw) -replace "`r`n","`n"
        $text > $_
    }

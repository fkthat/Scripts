# Quick delete node_modules

function Remove-NodeModules {
    Get-ChildItem . -Recurse -Filter node_modules |
        Remove-Item -Recurse -Force
}

# Git tools

function Clear-Git {
    Remove-NodeModules
    git clean -dfx -e .vs -e .vscode
}

function Start-VisualStudio {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string[]] 
        $Path)

    begin {
        $vs = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe"

        if(-not $Path) {
            $Path = (Get-ChildItem -Filter *.sln)
        }
    }

    process {
        $Path | ForEach-Object { & $vs $_ }
    }
}

function Start-VSCode {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string[]]
        $Path = '.')

    begin {
        $code = "${env:LocalAppData}\Programs\Microsoft VS Code\bin\code.cmd"
    }

    process {
        & $code $Path -n 
    }
}

# aliases
New-Alias clgit Clear-Git -Force
New-Alias vs Start-VisualStudio -Force
New-Alias code Start-VSCode -Force

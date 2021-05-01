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
        [string[]] $Solutions)

    $vs = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Preview\Common7\IDE\devenv.exe"

    if(-not $Solutions) {
        $Solutions = (Get-ChildItem -Filter *.sln)
    }

    $Solutions | ForEach-Object { & $vs $_ }
}

function Start-VSCode {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]
        $Agruments)

    $code = "${env:LocalAppData}\Programs\Microsoft VS Code\bin\code.cmd"

    if(-not $Agruments) {
        $Agruments = @("-n", ".")
    }

    Start-Process $code $Agruments
}

# aliases
New-Alias clgit Clear-Git -Force
New-Alias vs Start-VisualStudio -Force
New-Alias code Start-VSCode -Force

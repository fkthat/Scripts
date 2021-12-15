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
        $vs = "${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"

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

# Dotnet CLI autocomplete
# https://docs.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete#powershell

Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# aliases
New-Alias clgit Clear-Git -Force
New-Alias vs Start-VisualStudio -Force
New-Alias code Start-VSCode -Force

New-Alias dotnet "${env:ProgramFiles}\dotnet\dotnet.exe" -Force
New-Alias gh "${env:ProgramFiles(x86)}\GitHub CLI\gh.exe" -Force
New-Alias azds "${env:ProgramFiles}\Azure Data Studio\azuredatastudio.exe" -Force
New-Alias docker "${env:ProgramFiles}\Docker\Docker\resources\bin\docker.exe" -Force
New-Alias minikube "${env:ProgramFiles}\Kubernetes\Minikube\minikube.exe" -Force
New-Alias sqlcmd "${env:ProgramFiles}\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE" -Force

New-Alias az "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\CLI2\wbin\az.cmd" -Force
New-Alias decompile "${env:ProgramFiles(x86)}\Progress\JustDecompile\Libraries\JustDecompile.exe" -Force
New-Alias dotnet-core-uninstall "${env:ProgramFiles(x86)}\dotnet-core-uninstall\dotnet-core-uninstall.exe" -Force
New-Alias sqlite3 "${env:LocalAppData}\Programs\Sqlite\sqlite3.exe" -Force
New-Alias nuget "${env:LocalAppData}\Programs\NuGet\nuget.exe" -Force

# GitHub CLI autocomplete
Invoke-Expression -Command $(gh completion -s powershell | Out-String)

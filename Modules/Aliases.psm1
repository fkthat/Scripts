#
# Bins
#

if($PSVersionTable.Platform -eq "Win32NT") {
    Set-Alias scp "${env:SystemRoot}\System32\OpenSSH\scp.exe"
    Set-Alias ssh "${env:SystemRoot}\System32\OpenSSH\ssh.exe"

    Set-Alias 7z "${env:ProgramFiles}\7-zip\7z.exe"
    Set-Alias gh "${env:ProgramFiles}\GitHub CLI\gh.exe"
    Set-Alias less "${env:ProgramFiles}\Git\usr\bin\less.exe"
    Set-Alias paint "${env:ProgramFiles}\paint.net\PaintDotNet.exe"
    Set-Alias procexp "${env:ProgramFiles}\WindowsApps\Microsoft.SysinternalsSuite_2.0.1.0_x64__8wekyb3d8bbwe\Tools\procexp.exe"
    Set-Alias vi "${env:ProgramFiles}\Vim\vim82\vim.exe"
    Set-Alias vim "${env:ProgramFiles}\Vim\vim82\vim.exe"

    Set-Alias dotnet-core-uninstall "${env:ProgramFiles(x86)}\dotnet-core-uninstall\dotnet-core-uninstall.exe"
    Set-Alias glab "${env:ProgramFiles(x86)}\glab\glab.exe"

    Set-Alias azds "${env:LocalAppData}\Programs\Azure Data Studio\azuredatastudio.exe"
    Set-Alias dos2unix "${env:LocalAppData}\Programs\dos2unix\bin\dos2unix.exe"
    Set-Alias nuget "${env:LocalAppData}\Programs\NuGet\nuget.exe"
    Set-Alias unix2dos "${env:LocalAppData}\Programs\dos2unix\bin\unix2dos.exe"

    Set-Alias winget "${env:LocalAppData}\Microsoft\WindowsApps\winget.exe"
}

#
# PWSH
#

Set-Alias help Get-Help

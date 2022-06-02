#
# Bins
#

if($PSVersionTable.Platform -eq "Win32NT") {
    Set-Alias scp "${env:SystemRoot}\System32\OpenSSH\scp.exe"
    Set-Alias ssh "${env:SystemRoot}\System32\OpenSSH\ssh.exe"

    Set-Alias 7z "${env:ProgramFiles}\7-zip\7z.exe"
    Set-Alias bash "${env:ProgramFiles}\Git\bin\bash.exe"
    Set-Alias docker "${env:ProgramFiles}\Docker\Docker\resources\bin\docker.exe"
    Set-Alias less "${env:ProgramFiles}\Git\usr\bin\less.exe"
    Set-Alias minikube "${env:ProgramFiles}\Kubernetes\Minikube\minikube.exe"
    Set-Alias paint "${env:ProgramFiles}\paint.net\PaintDotNet.exe"
    Set-Alias sqlcmd "${env:ProgramFiles}\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE"
    Set-Alias gh "${env:ProgramFiles}\GitHub CLI\gh.exe"
    Set-Alias microk8s "${env:ProgramFiles}\MicroK8s\microk8s.exe"

    Set-Alias az "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\CLI2\wbin\az.cmd"
    Set-Alias decompile "${env:ProgramFiles(x86)}\Progress\JustDecompile\Libraries\JustDecompile.exe"
    Set-Alias glab "${env:ProgramFiles(x86)}\glab\glab.exe"
    Set-Alias dotnet-core-uninstall "${env:ProgramFiles(x86)}\dotnet-core-uninstall\dotnet-core-uninstall.exe"

    Set-Alias azds "${env:LocalAppData}\Programs\Azure Data Studio\azuredatastudio.exe"
    Set-Alias dos2unix "${env:LocalAppData}\Programs\dos2unix\bin\dos2unix.exe"
    Set-Alias dtui "${env:LocalAppData}\Programs\dt1.8.3\drop\dtui.exe"
    Set-Alias ffmpeg "${env:LocalAppData}\Programs\ffmpeg\bin\ffmpeg.exe"
    Set-Alias nuget "${env:LocalAppData}\Programs\NuGet\nuget.exe"
    Set-Alias procexp "${env:LocalAppData}\Programs\Sysinternals\ProcessXP\procexp64.exe"
    Set-Alias sqlite3 "${env:LocalAppData}\Programs\Sqlite\sqlite3.exe"
    Set-Alias unix2dos "${env:LocalAppData}\Programs\dos2unix\bin\unix2dos.exe"
    Set-Alias vi "${env:LocalAppData}\Programs\vim\vim82\vim.exe"
    Set-Alias vim "${env:LocalAppData}\Programs\vim\vim82\vim.exe"
    Set-Alias pactester "${env:LocalAppData}\Programs\pactester\pactester.exe"
    Set-Alias winget "${env:LocalAppData}\Microsoft\WindowsApps\winget.exe"
}

#
# PWSH
#

Set-Alias help Get-Help

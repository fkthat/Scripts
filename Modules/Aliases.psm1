New-Alias scp "${env:SystemRoot}\System32\OpenSSH\scp.exe" -Force
New-Alias ssh "${env:SystemRoot}\System32\OpenSSH\ssh.exe" -Force

New-Alias 7z "${env:ProgramFiles}\7-zip\7z.exe" -Force
New-Alias bash "${env:ProgramFiles}\Git\bin\bash.exe" -Force
New-Alias docker "${env:ProgramFiles}\Docker\Docker\resources\bin\docker.exe" -Force
New-Alias less "${env:ProgramFiles}\Git\usr\bin\less.exe" -Force
New-Alias minikube "${env:ProgramFiles}\Kubernetes\Minikube\minikube.exe" -Force
New-Alias paint "${env:ProgramFiles}\paint.net\PaintDotNet.exe" -Force
New-Alias sqlcmd "${env:ProgramFiles}\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE" -Force

New-Alias az "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\CLI2\wbin\az.cmd" -Force
New-Alias decompile "${env:ProgramFiles(x86)}\Progress\JustDecompile\Libraries\JustDecompile.exe" -Force
New-Alias gh "${env:ProgramFiles(x86)}\GitHub CLI\gh.exe" -Force

New-Alias azds "${env:LocalAppData}\Programs\Azure Data Studio\azuredatastudio.exe" -Force
New-Alias dos2unix "${env:LocalAppData}\Programs\dos2unix\dos2unix.exe" -Force
New-Alias dtui "${env:LocalAppData}\Programs\dt1.8.3\drop\dtui.exe" -Force
New-Alias ffmpeg "${env:LocalAppData}\Programs\ffmpeg\bin\ffmpeg.exe" -Force
New-Alias nuget "${env:LocalAppData}\Programs\NuGet\nuget.exe" -Force
New-Alias procexp "${env:LocalAppData}\Programs\Sysinternals\ProcessXP\procexp64.exe" -Force
New-Alias sqlite3 "${env:LocalAppData}\Programs\Sqlite\sqlite3.exe" -Force
New-Alias unix2dos "${env:LocalAppData}\Programs\dos2unix\unix2dos.exe" -Force
New-Alias vi "${env:LocalAppData}\Programs\vim\vim82\vim.exe" -Force
New-Alias vim "${env:LocalAppData}\Programs\vim\vim82\vim.exe" -Force
New-Alias winget "${env:LocalAppData}\Microsoft\WindowsApps\winget.exe" -Force

#
# PWSH
#

New-Alias help Get-Help -Force

#
# SysTools
#

New-Alias gdi Get-DiskInfo -Force
New-Alias gdiff Get-Diff -Force
New-Alias ln New-ItemLink -Force
New-Alias su Start-AdminTerminal -Force
New-Alias touch Set-ItemDateTime -Force
New-Alias sed Edit-FileContent -Force
New-Alias pbimg Publish-BB -Force

#
# DevTools
#

New-Alias clgit Clear-Git -Force
New-Alias code Start-VSCode -Force
New-Alias vs Start-VisualStudio -Force
New-Alias cover New-CoverageReport -Force

#
# Search
#

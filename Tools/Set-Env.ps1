$MachinePath = '%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem'

$UserPath = '%ProgramFiles%\dotnet;%USERPROFILE%\.dotnet\tools;%ProgramFiles%\Git\cmd;' + `
    '%ProgramFiles%\nodejs;.\node_modules\.bin;%APPDATA%\npm'

setx /M PATH $MachinePath
setx PATH $UserPath
setx VBOX_USER_HOME "$env:USERPROFILE\VirtualBox\Config"

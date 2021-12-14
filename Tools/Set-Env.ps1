$MachinePath = 
    '%SystemRoot%\System32;' + `
    '%SystemRoot%;' + `
    '%SystemRoot%\System32\Wbem'

$UserPath = `
    '%ProgramFiles%\dotnet;' + `
    '%ProgramFiles%\Git\cmd;'

setx /M PATH $MachinePath
setx PATH $UserPath
setx VBOX_USER_HOME "$env:USERPROFILE\VirtualBox\Config"

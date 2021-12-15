$MachinePath =  `
    '%SystemRoot%\System32;' + `
    '%SystemRoot%;' + `
    '%SystemRoot%\System32\Wbem'

$UserPath = ''
    # '%ProgramFiles%\dotnet;' + `
    # '%ProgramFiles%\Git\cmd;'

setx /M PATH $MachinePath

if($UserPath) {
    setx PATH $UserPath
}
else {
    Remove-ItemProperty 'HKCU:\Environment' -Name 'PATH'
}

setx VBOX_USER_HOME "$env:USERPROFILE\VirtualBox\Config"

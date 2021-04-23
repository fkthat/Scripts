# Custom Prompt

function Prompt {
    $esc = [char]27;

    $cp = (Get-Location).Path

    if ($cp.StartsWith($HOME)) {
        $cp = '~' + $cp.Substring($HOME.Length)
    }

    return "PS " + `
        "$esc[92m" + "$env:USERNAME" + "@" + "$env:COMPUTERNAME" + ":" + `
        "$esc[34m" + "$cp" + `
        "$esc[37m" + "$ "
}

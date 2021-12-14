$dll = "${env:ProgramFiles}\dotnet\shared\Microsoft.WindowsDesktop.App\3.1.18\System.Windows.Forms.dll"

if(Test-Path $dll) {
    [System.Reflection.Assembly]::LoadFrom($dll)

    $ApiKey = `
        '01000000d08c9ddf0115d1118c7a00c04fc297eb01000000e4b16b938aa09249a4cb328c9969b496' +
        '000000000200000000001066000000010000200000008aac97451a45bb62bc6ff9767ada4682e3ee' +
        'a66aba7c3a71b50151267c138839000000000e8000000002000020000000445d4ceb76f1080f7426' +
        '40d088cc7702623df81a5a7e8f9c34933d7888f08cc550000000ed4f9ee60ca362e89d5f3d5ff10f' +
        '35e0d9c60e8e9dfe8e99648afc2064daaeba5b9e456727d501b95ee4d1ddbb881424b7170acf49e5' +
        '44bdb102ef75d28ce9ba9d644ecb557ed5a160b39c8ea12ee87440000000299cd00f1d1ae9bda5a3' +
        'ec9a225859d093eca16146b100d7297d81f6bf1db078c44e815ba8876bdadd779232863fe9a52c82' +
        'd4ea03c366eb93269dc344276317'

    function Publish-BB {
        [CmdletBinding()]
        param (
            [Parameter()]
            [float]
            $Scale = 67 # to 67% (i.e. 1.5 as smaller)
        )

        $secret = ConvertTo-SecureString $ApiKey
        $secret = ConvertFrom-SecureString $secret -AsPlainText
        $Url = "https://api.imgbb.com/1/upload?key=$secret"

        $Img = [System.Windows.Forms.Clipboard]::GetImage()

        if ($Img) {
            try {
                [int] $W = $Img.Width * $Scale / 100
                [int] $H = $Img.Height * $Scale / 100
                $Scaled = New-Object 'System.Drawing.Bitmap' $Img, $W, $H

                try {
                    $Buf = New-Object 'System.IO.MemoryStream'
                    $Scaled.Save($Buf, [System.Drawing.Imaging.ImageFormat]::Png)
                    $B64 = [System.Convert]::ToBase64String($Buf.ToArray())

                    $Json = Invoke-WebRequest $Url -Method POST -Form @{ image = $B64 } |
                    ConvertFrom-Json

                    Write-Output $Json.data.url
                }
                finally {
                    $Scaled.Dispose()
                }
            }
            finally {
                $Img.Dispose()
            }
        }
    }

    New-Alias pbimg Publish-BB -Force
    Export-ModuleMember 'Publish-BB'
    Export-ModuleMember -Alias 'pbimg'
}

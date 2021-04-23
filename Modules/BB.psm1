[System.Reflection.Assembly]::LoadFrom(
    "${env:ProgramFiles}\dotnet\shared\Microsoft.WindowsDesktop.App\3.1.13\System.Windows.Forms.dll")

$ApiKey = '01000000d08c9ddf0115d1118c7a00c04fc297eb01000000ba083c6a0e76564d874416c8fc43731c' +
'00000000020000000000106600000001000020000000a928585187e9955d8113e452590c5138c68c6f1e20f382' +
'8de2ae8c4ed39ed2a8000000000e80000000020000200000009e49fa6fe7c46329c37dfbb4468d5c3570dd39a9' +
'e720ce45ae3f66a208a499435000000017047611d1d1f85c3429e0329f3d14f799668dd70a822ecea229300985' +
'f7d530a87fc480e79e7ea7c7a9e2ef38e8b831075a2579cb206afc720ea8f1cf35662aeea20a55cf677f521b45' +
'50c88d360b0240000000ede2b3ccc2b753e1b51efb12feab64ccdb59088182b1b0a2252474fd149d62fed089e5' +
'7ae8951df30cf83e0d7cfcfc3a2f6685de0cebb278fcaa068e77ecb91d'

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

    if($Img) {
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

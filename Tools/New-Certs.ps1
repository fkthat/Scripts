$ca = 'FkThat Development CA'
$domain = 'home.arpa'

$password =
'01000000d08c9ddf0115d1118c7a00c04fc297eb01000000ba083c6a0e76564d874416c8fc43731c00' +
'000000020000000000106600000001000020000000d6270abe28ca84a2d45a4d571090ba349432b842' +
'7a8b631b9f6c52779b8073ca000000000e8000000002000020000000f9a4eb15f682aefb43dacc67' +
'147ba50530259f64f695c120fcffb99d8fc9a7ab20000000701f48215ce2b84c7f7f2cc607f7b9c7' +
'd7595b85e84409e81115c91bf762c69e4000000099923a60670c2f3c9cb8ca8b5f3510d008d34fd1' +
'9fff81328b3903edaf0da7763fb454d9667fefc25c5aefce443c54ee1965b12504e17283c87a2b798f67eb31'

$caCert = New-SelfSignedCertificate `
    -DnsName $ca `
    -KeyLength 2048 `
    -KeyAlgorithm 'RSA' `
    -HashAlgorithm 'SHA256' `
    -KeyExportPolicy 'Exportable' `
    -NotAfter (Get-Date).AddYears(5) `
    -CertStoreLocation 'Cert:\CurrentUser\My' `
    -KeyUsage 'CertSign','CRLSign'

$cert = New-SelfSignedCertificate `
    -DnsName "*.$domain" `
    -Signer $caCert `
    -KeyLength 2048 `
    -KeyAlgorithm 'RSA' `
    -HashAlgorithm 'SHA256' `
    -KeyExportPolicy 'Exportable' `
    -NotAfter (Get-date).AddYears(2) `
    -CertStoreLocation 'Cert:\CurrentUser\My'

$caCrtFile = ($ca -replace '\s+','_') + '.crt'
Export-Certificate -Cert $caCert -FilePath $caCrtFile -Force | Out-Null
Import-Certificate -CertStoreLocation 'Cert:\CurrentUser\Root' -FilePath $caCrtFile
$secure = (ConvertTo-SecureString $password)
Export-PfxCertificate $cert "${domain}.pfx" -Password $secure -Force | Out-Null

$O = "$env:USERPROFILE\wifi-wachtwoorden.txt"
$P = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object { $_.ToString().Split(":")[1].Trim() }
if (Test-Path $O) { Clear-Content $O }

foreach ($I in $P) {
    $R = netsh wlan show profile name="$I" key=clear
    $S = $I
    $A = ($R | Select-String "Authentication" | ForEach-Object { $_.ToString().Split(":")[1].Trim() })
    $C = ($R | Select-String "Cipher" | ForEach-Object { $_.ToString().Split(":")[1].Trim() })
    $K = $R | Select-String "Key Content" | ForEach-Object { $_.ToString().Split(":")[1].Trim() }

    Add-Content $O "`nSSID: $S"
    Add-Content $O "Authenticatie: $A"
    Add-Content $O "Encryptie: $C"
    
    if ($K) {
        Add-Content $O "Wachtwoord: $K`n"
    } else {
        Add-Content $O "Wachtwoord: Niet beschikbaar`n"
    }
}

Invoke-Item $O
Start-Sleep -Seconds 5
Remove-Item $O -Force

# Wist de PowerShell geschiedenis
Clear-History

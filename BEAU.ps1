# Name: BEAU - Bulk Exchange Account Update
# Author: Connor Lynn
# Version: 1.0RC1

$csv = Import-csv "C:\Users\`$lynnc\Desktop\1Mailboxes.csv"

ForEach ($line in $csv) {
    $OldName = $line.CurrentDisplayName.Trim()
    $NewName = $line.NewDisplayName.Trim()

    $OldEmail = $line.CurrentEmailAddress.Trim()
    $NewEmail = $line.NewEmailAddress.Trim()
           
    Write-Host '======================================================='
    Write-Host `r`n
    try {
        $Mail_obj = get-mailbox -resultsize unlimited $OldEmail
    }
    catch {
        Write-Host "Unable to find $OldName"
        continue
    }
    Write-Host `r`n
    Write-Host $Mail_obj | Select Name
    Write-Host "Current: ", $OldName
    Write-Host "Change to: ", $NewName
    Write-Host "Current: ", $OldEmail
    Write-Host "Change to: ", $NewEmail
    Write-Host `r`n

    $NewAlias = $NewEmail.Split('@')[0]

    # Change stuff.
    Set-Mailbox $OldEmail -Name $NewName -DisplayName $NewName -EmailAddresses @{add=$NewEmail}

    Set-Mailbox $NewName -Alias $NewAlias -PrimarySmtpAddress $NewEmail

    start-Sleep -s 5

    $Mail_obj = get-mailbox -resultsize unlimited $NewEmail

    # checks for change
    if ($Mail_obj.Name -eq $NewName){
        Write-Host 'New Name Set.' -ForegroundColor Green
    } else {
        Write-Host 'New Name Not Set' -ForegroundColor Red
    }

    if ($Mail_obj.DisplayName -eq $NewName){
        Write-Host 'New Display Name Set.' -ForegroundColor Green
    } else {
        Write-Host 'New Display Name Not Set' -ForegroundColor Red
    }

    if ($Mail_obj.Alias -eq $NewAlias){
        Write-Host 'New Alias Set.' -ForegroundColor Green
    } else {
        Write-Host 'New Alias Not Set' -ForegroundColor Red
    }


    if ($Mail_obj.PrimarySmtpAddress -eq $NewEmail){
        Write-Host 'Primary Email Address Set.' -ForegroundColor Green
    } else {
        Write-Host 'Primary Email Address Not Set' -ForegroundColor Red
    }

    Write-Host `r`n
    Write-Host '======================================================='
    Write-Host `r`n
}
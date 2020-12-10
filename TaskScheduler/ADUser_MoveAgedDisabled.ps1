## ran by task scheduler
## script disables users whose password is older than the defined age then moves the user to the disabled OU
## once a disabled user has been disabled for 365 days then the account is deleted
##
########################################################################################################################
########################################################################################################################
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Import-Module ActiveDirectory

## custom variables#####################################################################################################
$PassAge = "120" ## modify for the number of days old a password must be before being disabled.
$DisAge = "365" ## modify for the number of days an account must be before being deleted.

########################################################################################################################
##### start of script ###### start of script ###### start of script ###### start of script ###### start of script ######
########################################################################################################################
$wmiDomain = Get-WmiObject Win32_NTDomain -Filter "DnsForestName = '$( (Get-WmiObject Win32_ComputerSystem).Domain)'"
$SrceDN = $wmiDomain.DomainName
$DomainDN = Get-ADDomain | select -ExpandProperty DistinguishedName  
$DisOU = "OU=DisabledUsers,OU=Users,OU=$SrceDN,$DomainDN" ## modify for the disabled OU's distinguishedName
$ExclOU = "OU=Service Accounts,OU=$SrceDN,$DomainDN" ## modify for a distinguishedName to be excluded
$LogDate = get-date -f yyyyMMddhhmm
$SearchBase = Get-ADDomain | select -ExpandProperty DistinguishedName
$LogArray = @()
$PasswordAge = (Get-Date).adddays(-$PassAge)
$RegEx = ‘^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](20)\d\d$’
$Disabledage = (get-date).adddays(-$DisAge)
ForEach ($DisabledUser in (Get-ADUser -searchbase $SearchBase -filter {((lastlogondate -le $Passwordage -or lastlogondate -notlike "*")) -and (whenCreated -le $Passwordage) -and (name -notlike "*Service*") -and (name -notlike "svc*") -and (PasswordNeverExpires -eq $False) -AND (passwordlastset -le $Passwordage) -and (samaccounttype -notlike 805306370 ) -AND (enabled -eq $True)} -properties LastLogonDate, whenCreated )) {
  Disable-ADAccount $DisabledUser

    $obj = New-Object PSObject
    $obj | Add-Member -MemberType NoteProperty -Name “Name” -Value $DisabledUser.name
    $obj | Add-Member -MemberType NoteProperty -Name “samAccountName” -Value $DisabledUser.samaccountname
    $obj | Add-Member -MemberType NoteProperty -Name “DistinguishedName” -Value $DisabledUser.DistinguishedName
    $obj | Add-Member -MemberType NoteProperty -Name “Status” -Value ‘Disabled’
    $obj | Add-Member -MemberType NoteProperty -Name "Last Logon" -value $DisabledUser.LastLogonDate
    $obj | Add-Member -MemberType NoteProperty -Name "Creation Date" -value $DeletedUser.whenCreated
    $LogArray += $obj
}
$DisabledAccounts = Get-ADUser -filter { enabled -eq $false } | Where {$_.DistinguishedName -notlike "*$ExclOU"}
ForEach ($account in $DisabledAccounts) {
Set-ADObject -Identity $account.distinguishedName -ProtectedFromAccidentalDeletion $false
Move-ADObject -Identity $account.distinguishedName -TargetPath $DisOU
}
$wmiDomain = Get-WmiObject Win32_NTDomain -Filter "DnsForestName = '$( (Get-WmiObject Win32_ComputerSystem).Domain)'"
$Domain = $wmiDomain.DomainName
$logArray | Export-Csv  "C:\tmp\$Domain-DisableAgedMove-$logDate.csv” -NoTypeInformation

########################################################################################################################
###### End of script ######## End of script ######## End of script ######## End of script ######## End of script #######
########################################################################################################################
########################################### Disclaimer for custom scripts ##############################################
###### The sample scripts are not supported under any ANY standard support program or service. The sample scripts ######
###### are provided AS IS without warranty of any kind. The author further disclaims all implied warranties       ######
###### including, without limitation, any implied warranties of merchantability or of fitness for a particular    ######
###### purpose. The entire risk arising out of the use or performance of the sample scripts and documentation     ######
###### remains with you. In no event shall the author, its authors, or anyone else involved in the creation,      ######
###### production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation,######
###### damages for loss of business profits, business interruption, loss of business information, or other        ######
###### pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if ######
###### the author has been advised of the possibility of such damages.                                            ######
########################################### Disclaimer for custom scripts ##############################################
#####################################################################################################################bps
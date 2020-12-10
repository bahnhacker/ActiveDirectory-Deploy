## ran by task scheduler
## script is used as a logon script to domain controllers to monitor modifications to Privileged Groups
##
########################################################################################################################
########################################################################################################################
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Import-Module ActiveDirectory

########################################################################################################################
$wmiDomain = Get-WmiObject Win32_NTDomain -Filter "DnsForestName = '$( (Get-WmiObject Win32_ComputerSystem).Domain)'"
$SrceDN = $wmiDomain.DomainName


Function Get-PrivilegedGroupChanges {            
Param(            
    $Server = (Get-ADDomainController -Discover | Select-Object -ExpandProperty HostName),            
    $Hour = 24            
)            
            
    $ProtectedGroups = Get-ADGroup -Filter 'AdminCount -eq 1' -Server $Server            
    $Members = @()            
            
    ForEach ($Group in $ProtectedGroups) {            
        $Members += Get-ADReplicationAttributeMetadata -Server $Server `
            -Object $Group.DistinguishedName -ShowAllLinkedValues |            
         Where-Object {$_.IsLinkValue} |            
         Select-Object @{name='GroupDN';expression={$Group.DistinguishedName}}, `
            @{name='GroupName';expression={$Group.Name}}, *            
    }            
            
    $Members |            
        Where-Object {$_.LastOriginatingChangeTime -gt (Get-Date).AddHours(-1 * $Hour)}            
            
}            
            
            
## Last 24 hours
$24hrs = Get-Date -f yyyyMMdd
Get-PrivilegedGroupChanges -Hour (1*24) | Export-Csv -Path "C:\tmp\PrivGrpChanges_$24hrs.csv" -NoTypeInformation -Append          

## Last month
$mo = Get-Date -f yyyyMM    
Get-PrivilegedGroupChanges -Hour (24*30) | Export-Csv -Path "C:\tmp\PrivGrpChanges_$mo.csv" -NoTypeInformation -Append     

## Last year
$yr = Get-Date -f yyyy
Get-PrivilegedGroupChanges -Hour (365*24) | Export-Csv -Path "C:\$SrceDN\PrivGrpChanges_$yr.csv" -NoTypeInformation -Append 
    
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
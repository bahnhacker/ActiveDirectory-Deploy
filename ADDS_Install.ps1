## Client; Project Name
## installs active directory domain services
##
## script can be ran in its entirety once the variables have been defined
##
##
## created/modified: 202003
########################################################################################################################
########################################################################################################################
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Import-Module ServerManager

## variables############################################################################################################
$DomainName = "contoso.com"
$AD_Database_Path = "D:"

########################################################################################################################
##### start of script ###### start of script ###### start of script ###### start of script ###### start of script ######
########################################################################################################################
$Date = Get-Date -f yyyyMMddhhmm

## creates location to store temporary files############################################################################
New-Item -Path "C:\" -Name "tmp" -ItemType "directory"
$wshshell = New-Object -ComObject WScript.Shell
$desktop = [System.Environment]::GetFolderPath('Desktop')
  $lnk = $wshshell.CreateShortcut($desktop+"\tmp.lnk")
  $lnk.TargetPath = "C:\tmp"
  $lnk.Save() 

$OutputPath = "C:\tmp"

## verify server information############################################################################################
function Get-SystemInfo 
{ 
  param($ComputerName = $env:ComputerName) 
  
      $header = 'Hostname','OSName','OSVersion','OSManufacturer','OSConfig','Buildtype', 'RegisteredOwner','RegisteredOrganization','ProductID','InstallDate', 'StartTime','Manufacturer','Model','Type','Processor','BIOSVersion', 'WindowsFolder' ,'SystemFolder','StartDevice','Culture', 'UICulture', 'TimeZone','PhysicalMemory', 'AvailablePhysicalMemory' , 'MaxVirtualMemory', 'AvailableVirtualMemory','UsedVirtualMemory','PagingFile','Domain' ,'LogonServer','Hotfix','NetworkAdapter' 
      systeminfo.exe /FO CSV /S $ComputerName |  
            Select-Object -Skip 1 |  
            ConvertFrom-CSV -Header $header 
} 
Get-SystemInfo -ComputerName $env:COMPUTERNAME
$a = new-object -comobject wscript.shell
$b = $a.popup(“Please confirm the System Information, specifically the HostName and IP Address. Press OK to CONTINUE or Cancel to STOP if there is an error.“,0,“Please confirm SysInfo:”,1)
Get-SystemInfo -ComputerName $env:COMPUTERNAME | Out-File -FilePath "$OutputPath\SysInfo-$Date.csv" -Force

## Installs Active Directory Domain Services & DNS######################################################################
Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
Install-WindowsFeature DNS -IncludeAllSubFeature -IncludeManagementTools

## creates the domain###################################################################################################
Import-Module ADDSDeployment
Import-Module DnsServer
Install-ADDSForest -DomainName $DomainName -InstallDns -DomainMode WinThreshold -ForestMode WinThreshold -DatabasePath $AD_Database_Path\Windows\NTDS -SysvolPath $AD_Database_Path\Windows\SYSVOL -LogPath $AD_Database_Path\Windows\Logs -Force


########################################################################################################################
###### end of script ######## end of script ######## end of script ######## end of script ######## end of script #######
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
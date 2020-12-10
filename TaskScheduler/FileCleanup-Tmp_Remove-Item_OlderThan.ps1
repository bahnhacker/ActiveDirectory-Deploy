## ran by task scheduler
## script deletes files in targeted locations older than a set age
##
########################################################################################################################
########################################################################################################################
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

## custom variables#####################################################################################################
$DeleteAge = "-120"

########################################################################################################################
##### start of script ###### start of script ###### start of script ###### start of script ###### start of script ######
########################################################################################################################
$Path = "C:\tmp"
Get-ChildItem –Path $Path -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays($DeleteAge))} | Remove-Item -Force

    
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
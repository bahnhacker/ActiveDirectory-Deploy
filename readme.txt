The pkg-ActiveDirectory-Deploy.zip should be copied to the server that will be used to provision the new domain and unzipped to a desired location. Update the variables within the installation script, ADDS-Install.ps1, with the desired domain name and location for ADDS file then run the script in its entirety. Upon reboot, log into the domain controller, update the configuration script, ADDS-Config.ps1, with the desired password settings and run the script in its entirety. The script will prompt for all other information. 

-------------------------------------------------------------------------------------------------------------------


ADDS Configurations Include:
• Active Directory Features
  o Enables AD DS Auditing
  o Enables AD RecycleBin
  o Enables gMSA
• Active Directory Domains and Trusts; prompts the user to configure any required Domain Trust and simultaneously creates Conditional Forwarders for the Domains to be trusted. 
• Active Directory Sites and Services; prompts the user to add the primary subnet, links the subnet to the default site, prompts the user to rename the default site, prompts the user to create additional sites, prompts the user to add additional subnets and links them to the identified site. This section also creates the appropriate DNS records to support the domain.
• Active Directory Users and Computers; creates a common OU structure, creates common domain groups, creates a gMSA for the Domain Controllers to utilize for Scheduled Tasks.
• DNS; prompts the user to configure a Forwarder and enables Scavenging.
• Group Policy; creates WMI filters. 
• Scheduled Tasks; creates scheduled tasks using the gMSA for (1) Identifying, Moving, and Disabling stale User Objects; (2) File Cleanup of the C:\tmp file location configured and used during this deployment and by additional scripts; and (3) Privileged Groups Monitoring which creates a report of modifications to privileged groups.
• Fine-Grained Password Policies, PSO; creates common PSOs for Service Accounts, Users, and Privileged Accounts.
• Installs the AD Asset Report Utility 
• The unzipped kit is deleted

-------------------------------------------------------------------------------------------------------------------

This has been successfully tested on Windows Server 2012r2, 2016 and 2019. The domain created will be at the highest functional level allowed. 
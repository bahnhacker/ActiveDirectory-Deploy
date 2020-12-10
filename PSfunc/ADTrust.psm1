Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Function New-ADDomainTrust
{
	Param
	(
		[parameter(Mandatory=$true)]
		[String]$RemoteDomain,
		[parameter(Mandatory=$true)]
		[String]$RemoteAdmin,
		[parameter(Mandatory=$true)]
		[String]$RemotePassword,
		[parameter(Mandatory=$true)]
		[ValidateSet("Inbound", "Outbound", "Bidirectional")]
		[String]$TrustDirection
	)

	$remoteConnection = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Domain',$RemoteDomain,$RemoteAdmin,$RemotePassword)
	$remoteDomainConnection = [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain($remoteConnection)
	$localDomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
	$localDomain.CreateTrustRelationship($remoteDomainConnection,$TrustDirection)
}

Function Remove-ADDomainTrust
{
	Param
	(
		[parameter(Mandatory=$true)]
		[String]$RemoteDomain,
		[parameter(Mandatory=$true)]
		[String]$RemoteAdmin,
		[parameter(Mandatory=$true)]
		[String]$RemotePassword
	)

	$remoteConnection = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Domain',$RemoteDomain,$RemoteAdmin,$RemotePassword)
	$remoteDomainConnection = [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain($remoteConnection)
	$localDomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
	$localDomain.DeleteTrustRelationship($remoteDomainConnection)
}

Function New-ADForestTrust
{
	Param
	(
		[parameter(Mandatory=$true)]
		[String]$RemoteForest,
		[parameter(Mandatory=$true)]
		[String]$RemoteAdmin,
		[parameter(Mandatory=$true)]
		[String]$RemotePassword,
		[parameter(Mandatory=$true)]
		[ValidateSet("Inbound", "Outbound", "Bidirectional")]
		[String]$TrustDirection
	)

	$remoteConnection = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Forest',$RemoteForest,$RemoteAdmin,$RemotePassword)
	$remoteForestConnection = [System.DirectoryServices.ActiveDirectory.Forest]::GetForest($remoteConnection)
	$localForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
	$localForest.CreateTrustRelationship($remoteForestConnection,$TrustDirection)
}

Function Remove-ADForestTrust
{
	Param
	(
		[parameter(Mandatory=$true)]
		[String]$RemoteForest,
		[parameter(Mandatory=$true)]
		[String]$RemoteAdmin,
		[parameter(Mandatory=$true)]
		[String]$RemotePassword
	)

	$remoteConnection = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Forest',$RemoteForest,$RemoteAdmin,$RemotePassword)
	$remoteForestConnection = [System.DirectoryServices.ActiveDirectory.Forest]::GetForest($remoteConnection)
	$localForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
	$localForest.DeleteTrustRelationship($remoteForestConnection)
}

Export-ModuleMember -Function New-ADDomainTrust, Remove-ADDomainTrust, New-ADForestTrust, Remove-ADForestTrust
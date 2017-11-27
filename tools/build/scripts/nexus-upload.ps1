<#
	.SYNOPSIS
	Upload a file to the Nexus repository.

	.DESCRIPTION
	Upload a file to the Nexus repository.

	.PARAMETER Filename
	The file to be uploaded. Required.

	.PARAMETER UserID
	The Nexus user's ID. Required.

	.PARAMETER UserPass
	The Nexus user's Password. Required.
#>

Param(
	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$Filename,

	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$UserID,

	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$UserPass
)

# Calculate the upload destination URL.
$config = (Get-Content "config.json") -join "`n" | ConvertFrom-Json
$remoteUrl = $config.baseUrl.Trim()
if ( -not $remoteUrl.EndsWith('/') ) { $remoteUrl = $remoteUrl + '/' }
$remoteUrl = $remoteUrl + $Filename

# Create login credential
$securePassword = ConvertTo-SecureString $UserPass -AsPlainText -Force
$credential = New-Object PSCredential ($UserID, $securePassword)


$uploadParams = @{
	Uri = $remoteUrl;
	Method = 'PUT';
	Credential = $credential;
	InFile = $Filename;
}

$result = Invoke-RestMethod @uploadParams

Write-Host $result	


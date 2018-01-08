<#
	.SYNOPSIS
	Retrieves a file from the Nexus repository.

	.DESCRIPTION
	Retrieves a file from the Nexus repository.

	.PARAMETER Filename
	The file to be downloaded. Required.

	.PARAMETER UserID
	The Nexus user's ID. Required.

	.PARAMETER UserPass
	The Nexus user's Password. Required.

	.PARAMETER Destination
	The location for storing the downloaded file.
#>

Param(
	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$Filename,

	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$UserID,

	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$UserPass,

	[Parameter(mandatory=$false, ValueFromPipeline=$false)]
	[string]$Destination = "."
)

# Calculate the save file name.
$SaveLocation = Join-Path -path $Destination $Filename


# Calculate the upload destination URL.
$configFile = [System.IO.Path]::Combine($PSScriptRoot, "nexus-config.json")
$config = (Get-Content $configFile) -join "`n" | ConvertFrom-Json
$remoteUrl = $config.baseUrl.Trim()
if ( -not $remoteUrl.EndsWith('/') ) { $remoteUrl = $remoteUrl + '/' }
$remoteUrl = $remoteUrl + $Filename

# Create login credential
$securePassword = ConvertTo-SecureString $UserPass -AsPlainText -Force
$credential = New-Object PSCredential ($UserID, $securePassword)


$downloadParams = @{
	Uri = $remoteUrl;
	Method = 'GET';
	Credential = $credential;
	OutFile = $SaveLocation;
}

$result = Invoke-RestMethod @downloadParams

Write-Host $result

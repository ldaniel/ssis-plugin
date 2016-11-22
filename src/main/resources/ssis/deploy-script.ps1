$_DtUtilPathEXE = $($deployed.container.DtUtilPath) + "dtutil.exe"
$_InstanceName = $($deployed.container.InstanceName)
$_FolderName = $($deployed.container.FolderName)
$_TempPath = $($deployed.container.TempPath)

function ExecuteDeployment()
{
	Write-Host "Instance name: $_InstanceName" 
	Write-Host "SSIS folder: $_FolderName"
	Write-Host "Temp path: $_TempPath" 

	# Call function to copy all deployables to target directory
	CopyDeployables

	# Call function to install the Windows Service
	InstallSSISPackage
}

function CopyDeployables
{
	PrintMessage "Deleting all files from temp folder..."
	if (Test-Path $_TempPath) 
	{
		Get-ChildItem -Path $_TempPath -Recurse | Remove-Item -Force -Recurse | Out-Null
		Remove-Item $_TempPath -Force | Out-Null
	}
	
	PrintMessage "Unzipping and copying files to target directory..."
	$shell = new-object -com shell.application
	$zip = $shell.NameSpace($deployed.file)
	$x = New-Item -Path $_TempPath -ItemType directory
	foreach($item in $zip.items()) 
	{
		Write-Host "Copying package $($item.name)..."
		$shell.Namespace($_TempPath).copyhere($item)
	}
}

function InstallSSISPackage
{
	PrintMessage "Installing packages to SSIS server..."
	
	Get-ChildItem $_TempPath -Filter *.dtsx | 
	Foreach-Object {
		$packageName = $_.BaseName
		Write-Host "Installing package $($packageName)..."
	    &$_DtUtilPathEXE /File "$($_.FullName)" /DestServer $($_InstanceName) /Copy SQL`;"$($_FolderName)/$($packageName)" /Quiet
		
		if ($lastexitcode -ne 0) {
			Write-Host "Cannot install package at $packageName"
			Exit 1
		}
		else
		{
			Write-Host "Done!"
		}
		
		Write-Host "-----------------------------------------------------------------------------------------------------"
	}
}

function PrintMessage($message)
{
	Write-Host "-----------------------------------------------------------------------------------------------------"
	Write-Host "---- $message"
	Write-Host "-----------------------------------------------------------------------------------------------------"
}

ExecuteDeployment
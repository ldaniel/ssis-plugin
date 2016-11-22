$_InstanceName = $($deployed.container.InstanceName)
$_FolderName = $($deployed.container.FolderName)
$_TempPath = $($deployed.container.TempPath)

function ExecuteDeployment()
{
	Write-Host "Instance name: $_InstanceName" 
	Write-Host "SSIS folder: $_FolderName"
	Write-Host "Temp path: $_TempPath" 

	# Call function to delete all previous packages from temp folder
	DeleteTempFolder
}

function DeleteTempFolder
{
	PrintMessage "Deleting all files from temp folder..."
	if (Test-Path $_TempPath) 
	{
		Get-ChildItem -Path $_TempPath -Recurse | Remove-Item -Force -Recurse | Out-Null
		Remove-Item $_TempPath -Force | Out-Null
	}	
}

function PrintMessage($message)
{
	Write-Host "-----------------------------------------------------------------------------------------------------"
	Write-Host "---- $message"
	Write-Host "-----------------------------------------------------------------------------------------------------"
}

ExecuteDeployment
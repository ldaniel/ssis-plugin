$_TempPath = $($container.TempPath)
$_DtUtilPath = $($container.DtUtilPath)

function ExecuteCheck()
{

	If (Test-Path $_TempPath)
	{
		PrintMessageOk $_TempPath 
	}
	else
	{
		PrintHowToSolveIssue $_TempPath
		Exit 1
	}

	If (Test-Path $_DtUtilPath)
	{
		PrintMessageOk $_DtUtilPath 
	}
	else
	{
		PrintHowToSolveIssue $_DtUtilPath 
		Exit 1
	}
}

function PrintMessageOk($folder)
{
	Write-Host "-----------------------------------------------------------------------------------------------------"
	Write-Host "[OK!]"
	Write-Host "Folder '$($folder)' exists on server."	
}

function PrintHowToSolveIssue($folder)
{
	Write-Host "-----------------------------------------------------------------------------------------------------"
	Write-Host "[ERROR!]"
	Write-Host "Check task failed due the following reason: Folder '$($folder)' does not exists on server."	
	Write-Host "The folder '$($folder)' must be created on target server in order to solve this issue."	
}

ExecuteCheck
try{
	Write-Host "8otto's FiddlerScript Updater`nTHE INSTALLATION WILL OVERWRITE ANY PREVIOUSLY INSTALLED SCRIPTS!`nDo you want to continue? (Y\N)"
	$choice = ""
	while($choice -ine "y" -and $choice -ine "n"){
		$choice = Read-Host
	}
	switch ($choice) {
		'n' { exit }
	}
	$url = 'https://raw.githubusercontent.com/im8otto/dbd-fiddler/main/CustomScript.js'
	$destinationPath = Join-Path ([System.Environment]::GetFolderPath('MyDocuments')) "Fiddler2\Scripts\CustomRules.js"
	Invoke-WebRequest -Uri $url -OutFile $destinationPath
	Write-Host "CustomScript successfully updated to latest version!"
}
catch{
	Write-Host "Error, close Fiddler and launch updater again!"
}
finally{
	pause
	exit
}

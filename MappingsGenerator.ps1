$User32 = Add-Type -Debug:$False -MemberDefinition '[DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X,int Y, int cx, int cy, uint uFlags);' -Name "User32Functions" -namespace User32Functions -PassThru
$Handle = (Get-Process -pid $PID).MainWindowHandle
[Void]$User32::SetWindowPos($Handle, -1, 0, 0, 0, 0, 0x53)
$mappingsSettingsPath = ".\MappingsSettings.txt"
$injectorPath = "Injector.exe"
$dumperDll = "Dumper-7.dll"

if (-Not (Test-Path -Path "C:\Rules")) { New-Item -Path "C:\Rules" -Type Directory }

if (-Not (Test-Path -Path $mappingsSettingsPath)) {
    $exePath = (Read-Host "Enter the path of the executable to launch").Replace('"','')
    Set-Content $mappingsSettingsPath $exePath
} else {
    $exePath = Get-Content $mappingsSettingsPath
}

if (-Not ((Test-Path -Path $exePath) -and (Test-Path -Path $injectorPath) -and (Test-Path -Path $dumperDll))) {
    Write-Host "Invalid path. Ensure that you extracted all in same folder." -ForegroundColor Red
    pause
    exit
}

$gameRoot = (Get-Item $exePath).Directory.Parent.Parent.FullName
$dllPath = Join-Path -Path $gameRoot -ChildPath "Plugins\Runtime\Bhvr\OnlineSubsystemEpic\ThirdParty\EOS\SDK\Bin\EOSSDK-Win64-Shipping.dll"

if (Test-Path -Path $dllPath) {
    Rename-Item -Path $dllPath -NewName "EOSSDK-Win64-Shipping.dll.bak"
    Write-Host "EOSSDK-Win64-Shipping.dll successfully renamed to EOSSDK-Win64-Shipping.dll.bak"
}

Start-Process -FilePath $exePath -ArgumentList "-eac-nop-loaded"
Write-Host "Executable launched with parameter -eac-nop-loaded"

Write-Host "Waiting for the game to load to inject Dumper-7. DON'T PRESS ANYTHING!"
Start-Sleep -Seconds 30
$injectorArgs = "--process-name $([System.IO.Path]::GetFileName($exePath)) --inject $dumperDll"

$injectorProcess = Start-Process -FilePath $injectorPath -ArgumentList $injectorArgs -Wait -PassThru
Write-Host "Injector launched and waiting for completion, DON'T PRESS ANYTHING!"


Start-Sleep -Seconds 30
Stop-Process -Name $([System.IO.Path]::GetFileNameWithoutExtension($exePath)) -Force

if (Test-Path -Path "$dllPath.bak") {
    Rename-Item -Path "$dllPath.bak" -NewName "EOSSDK-Win64-Shipping.dll"
    Write-Host "EOSSDK-Win64-Shipping.dll.bak successfully renamed to EOSSDK-Win64-Shipping.dll"
}

$sourcePath = "C:\Dumper-7"
$destinationFile = "C:\Rules\DBD.usmap"
$latestFolder = Get-ChildItem -Path $sourcePath -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($latestFolder -and (Test-Path "$($latestFolder.FullName)\Mappings")) {
    $usmapFile = Get-ChildItem -Path "$($latestFolder.FullName)\Mappings" -Filter "*.usmap" | Select-Object -First 1
    if ($usmapFile) {
        Copy-Item -Path $usmapFile.FullName -Destination $destinationFile -Force
        Write-Host "Mappings file updated -> $destinationFile"
    }
}

pause
exit

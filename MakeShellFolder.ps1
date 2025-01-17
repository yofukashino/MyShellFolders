if (-not $Host.UI.SupportsVirtualTerminal -and $env:TERM -ne 'xterm') {
    Write-Host "Re-launching in an interactive session..."
    Start-Process powershell.exe -ArgumentList "-NoExit", "-Command", "& { irm 'https://yofukashino.github.io/MyShellFolders/MakeShellFolder.ps1' | iex }"
    exit
}

Add-Type -AssemblyName System.Windows.Forms
$FolderName = Read-Host "Enter the name of the folder"
$FolderHint = Read-Host "Enter a hint for the folder"
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowser.Description = "Select the folder location"
$FolderBrowser.RootFolder = [System.Environment+SpecialFolder]::Desktop  
if ($FolderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $FolderLocation = $FolderBrowser.SelectedPath
    Write-Host "Selected Folder: $FolderLocation"
} else {
    Write-Host "No folder selected. Exiting script."
    exit
}

$MYCLSID = ([guid]::NewGuid().ToString("B").ToUpper())
$HKCU_CLSID = "HKCU:\Software\Classes\CLSID\$MYCLSID"
$FolderDescriptions = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions"
$UserShellFolders = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"


# ##############################################################################
# Step 1: Register CLSID
# ##############################################################################
New-Item -Path $HKCU_CLSID
Set-ItemProperty -Path $HKCU_CLSID -Name "(Default)" -Value $FolderName
Set-ItemProperty -Path $HKCU_CLSID -Name "InfoTip" -Value $FolderHint

New-Item -Path "$HKCU_CLSID\DefaultIcon"
Set-ItemProperty -Path "$HKCU_CLSID\DefaultIcon" -Name "(Default)" -Value $FolderIcon

New-Item -Path "$HKCU_CLSID\InProcServer32"
Set-ItemProperty -Path "$HKCU_CLSID\InProcServer32" -Name "(Default)" -Value "shdocvw.dll"
Set-ItemProperty -Path "$HKCU_CLSID\InProcServer32" -Name "ThreadingModel" -Value "Both"

New-Item -Path "$HKCU_CLSID\Instance"
Set-ItemProperty -Path "$HKCU_CLSID\Instance" -Name "CLSID" -Value "{0afaced1-e828-11d1-9187-b532f1e9575d}"

# ##############################################################################
# Step 2: Define as a Known Folder
# ##############################################################################
$KnownFolderGUID = ([guid]::NewGuid().ToString("B").ToUpper())
$FolderDescriptionPath = "$FolderDescriptions\$KnownFolderGUID"

New-Item -Path $FolderDescriptionPath
Set-ItemProperty -Path $FolderDescriptionPath -Name "Name" -Value $FolderName
Set-ItemProperty -Path $FolderDescriptionPath -Name "Category" -Value 4 -Type DWORD
Set-ItemProperty -Path $FolderDescriptionPath -Name "Attributes" -Value 1 -Type DWORD
Set-ItemProperty -Path $FolderDescriptionPath -Name "RelativePath" -Value $FolderLocation
Set-ItemProperty -Path $FolderDescriptionPath -Name "ParsingName" -Value $FolderLocation
Set-ItemProperty -Path $FolderDescriptionPath -Name "LocalizedName" -Value $FolderName -Type ExpandString
Set-ItemProperty -Path $FolderDescriptionPath -Name "Icon" -Value "C:\\Windows\\System32\\Shell32.dll,3" -Type ExpandString

# ##############################################################################
# Step 3: Add to User Shell Folders
# ##############################################################################
New-ItemProperty -Path $UserShellFolders -Name "${KnownFolderGUID}" -Value $FolderLocation -PropertyType ExpandString
New-ItemProperty -Path $UserShellFolders -Name "${FolderName}" -Value $FolderLocation -PropertyType ExpandString

# ##############################################################################
# Step 4: Restart Explorer
# ##############################################################################
Stop-Process -ProcessName explorer

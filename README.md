

get-appxpackage Microsoft.WindowsTerminal -allusers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}

choco install lxrunoffline

copy /y /v %LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json <path>



https://cloud-images.ubuntu.com/focal/current/


winget install Microsoft.PowerToys --source winget

choco install lxrunoffline




install windows terminal 



run "shell:fonts" and copy contents of "fonts" folder


set icons  for distros:

https://assets.ubuntu.com/v1/49a1a858-favicon-32x32.png
https://static-00.iconduck.com/assets.00/file-type-terraform-icon-86x96-lub9dnat.png


%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\
copy settings.json to %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\

open json settings:



append fragment 

wt-schemes-ubuntu.json  to the shemes arrary:

save:

for profile, select Appearance:

Colur scheme: "Ubuntu-console" 
Font Face: Ubuntu Mono
Font Size: 13
Line Height: 1.3
Intense text style: None



if restoring from scratch, you may need to delete all proiles and restart the terminal to allow the Dynamic Profile process to rediscover them and add them with the correct uuids.



"hide from dropdown" and profile not in use.








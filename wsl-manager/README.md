



run 



run notepad.exe "%USERPROFILE%/.wslconfig"
can past contents of file from repo


---- reclaimm, disk 



Turns out I needed to install Hyper-V features on Windows (even though I don't need Hyper-V itself, I use VHD as portable file container)

    Go to Control Panel | Programs and features | Turn windows features on or off
    Tick Hyper-V | Hyper-V Management tools | Hyper-V Module for Windows PowerShell





Mount-VHD -Path "C:\Users\Vinny\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu20.04onWindows_79rhkp1fndgsc\LocalState\ext4.vhdx" -ReadOnly

Optimize-VHD -Path "C:\Users\Vinny\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu20.04onWindows_79rhkp1fndgsc\LocalState\ext4.vhdx" -Mode Full

Dismount-VHD "C:\Users\Vinny\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu20.04onWindows_79rhkp1fndgsc\LocalState\ext4.vhdx"





----------------------------------


"For Windows 10 Home (alternative Optimize-VHD cmdlet):

wsl --shutdown
diskpart
# open window Diskpart
select vdisk file="C:\WSL-Distros\…\ext4.vhdx"
attach vdisk readonly
compact vdisk
detach vdisk
exit

Thanks to @davidwin for the tip #4699 (comment)."





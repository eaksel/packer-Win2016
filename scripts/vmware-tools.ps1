# Source : https://github.com/luciusbono/Packer-Windows10/blob/master/install-guest-tools.ps1


$isopath = "C:\Windows\Temp\windows.iso"

# Mount the .iso, then build the path to the installer by getting the Driveletter attribute from Get-DiskImage piped into Get-Volume and adding a :\setup.exe
# A separate variable is used for the parameters. There are cleaner ways of doing this. I chose the /qr MSI Installer flag because I personally hate silent installers
# Even though our build is headless. 

Write-Output "***** Mounting disk image at $isopath"
Mount-DiskImage -ImagePath $isopath

function vmware {

$exe = ((Get-DiskImage -ImagePath $isopath | Get-Volume).Driveletter + ':\setup64.exe')
$parameters = '/S /v "/qn REBOOT=R ADDLOCAL=ALL"'

Start-Process $exe $parameters -Wait

}

Write-Output "***** Installing VMWare Guest Tools"
vmware

#Time to clean up - dismount the image and delete the original ISO

Write-Output "***** Dismounting disk image $isopath"
Dismount-DiskImage -ImagePath $isopath
Write-Output "***** Deleting $isopath"
Remove-Item $isopath
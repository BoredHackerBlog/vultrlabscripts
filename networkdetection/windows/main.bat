rem disable updates
sc config wuauserv start= disabled
net stop wuauserv

rem turn off firewall
netsh advfirewall set allprofiles state off

rem disable defender
powershell Set-MpPreference -DisableRealtimeMonitoring $true
powershell Add-MpPreference -ExclusionPath C:\
powershell Uninstall-WindowsFeature -Name Windows-Defender

rem assign ip to private network
cd C:\
powershell Invoke-WebRequest -Uri "https://raw.githubusercontent.com/BoredHackerBlog/vultrlabscripts/main/networkdetection/windows/changeip.ps1" -OutFile "changeip.ps1"
powerShell -ExecutionPolicy UnRestricted -File changeip.ps1


rem assign ip to private network
netsh interface ip set address name="Ethernet 2" static 10.2.96.5 255.255.255.0 0.0.0.0 1

rem disable updates
sc config wuauserv start= disabled
net stop wuauserv

rem turn off firewall
netsh advfirewall set allprofiles state off

rem disable defender
powershell Set-MpPreference -DisableRealtimeMonitoring $true
powershell Add-MpPreference -ExclusionPath C:\
powershell Uninstall-WindowsFeature -Name Windows-Defender

rem enable proccess auditing
auditpol /Set /subcategory:"Process Creation" /Success:Enable
auditpol /Set /subcategory:"Process Termination" /Success:Enable
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\Audit\ /v ProcessCreationIncludeCmdLine_Enabled /t REG_DWORD /d 1

rem enable powershell logging
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging" /v EnableModuleLogging /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames" /v * /t REG_SZ /d * /f /reg:64
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" /v EnableScriptBlockLogging /t REG_DWORD /d 00000001 /f /reg:64
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription" /v EnableTranscripting /t REG_DWORD /d 00000001 /f /reg:64
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription" /v OutputDirectory /t REG_SZ /d C:\PSTranscipts /f /reg:64
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription" /v EnableInvocationHeader /t REG_DWORD /d 00000001 /f /reg:64

rem enable all auditing (disable this if needed)
auditpol.exe /set /Category:* /success:enable
auditpol.exe /set /Category:* /failure:enable

rem create an smb share
powershell New-Item C:\Shares\ -ItemType Directory
powershell New-Item C:\Shares\SharedFiles -ItemType Directory
powershell New-SMBShare –Name SharedFiles –Path C:\Shares\SharedFiles

rem setup sysmon
powershell Invoke-WebRequest -Uri "https://raw.githubusercontent.com/olafhartong/sysmon-modular/master/sysmonconfig.xml" -OutFile "sysmonconfig.xml"
powershell Invoke-WebRequest -Uri "https://live.sysinternals.com/Sysmon.exe" -OutFile "sysmon.exe"
sysmon.exe -accepteula -i sysmonconfig.xml

rem setup winlogbeat
mkdir C:\loggingsetup
cd C:\loggingsetup

powershell Invoke-WebRequest -Uri "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-oss-7.15.1-windows-x86_64.zip" -OutFile "winlogbeat.zip"
powershell Expand-Archive -Path winlogbeat.zip -DestinationPath C:\loggingsetup\winlogbeat\

powershell Invoke-WebRequest -Uri "https://raw.githubusercontent.com/BoredHackerBlog/vultrlabscripts/main/logdetection/windows/winlogbeat.yml" -OutFile "winlogbeat.yml"

copy /y winlogbeat.yml winlogbeat\winlogbeat-7.15.1-windows-x86_64\winlogbeat.yml

cd C:\loggingsetup\winlogbeat\winlogbeat-7.15.1-windows-x86_64\
powerShell -ExecutionPolicy UnRestricted -File .\install-service-winlogbeat.ps1

rem reboot
shutdown /r /t 0
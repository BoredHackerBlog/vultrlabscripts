$ifaceindex = (Get-NetIPAddress | Where-Object -FilterScript { $_.IPAddress -Like "169.*" } | foreach { $_.InterfaceIndex})
route delete 0.0.0.0 -p
netsh interface ip set address $ifaceindex static 10.2.96.5 255.255.255.0 10.2.96.4 1

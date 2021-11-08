$ifaceindex = (Get-NetIPAddress | Where-Object -FilterScript { $_.IPAddress -Like "169.*" } | foreach { $_.InterfaceIndex})
netsh interface ip set address $ifaceindex static 10.2.96.5 255.255.255.0 0.0.0.0 1

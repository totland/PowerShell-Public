$Disk = Get-WmiObject Win32_LogicalDisk -Filter "Drivetype='3'" | Select-Object DeviceID,Size,FreeSpace
for ($i=0;$i -lt $Disk.DeviceID.Length; $i++) {
    write-host $env:computername, 
    $disk.DeviceID[$i], 
    ([int32]($disk.Size[$i]/1mb)), 
    ([int32]($disk.FreeSpace[$i]/1mb)), 
    ([int32](($Disk.FreeSpace[$i]/$Disk.Size[$i])*100))
}


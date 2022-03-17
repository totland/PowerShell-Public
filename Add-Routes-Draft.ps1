<# Script Notes
Author:  TJ Totland
This script will change the routes on a server by reading the existing
route table and looking for objects that would be on the backend network.
When it finds a backend network range, it will use that Gateway to the
new routes to be added.

Script in Draft, working to improve Error Controls
#>

$PersistedRouteTable = Get-WmiObject Win32_IP4PersistedRouteTable
$RouteTable = Get-WmiObject Win32_IP4RouteTable

#Find Management Gateway in ActiveRouteTable
Get-WmiObject Win32_IP4RouteTable | foreach-object {
    if ($_.Destination -eq "192.168.100.0"){$BackendGW = $_.Nexthop}
    }
if($lastexitcode -ne '0'){exit $ErrorLevel}

#Find Management Gateway in PersistedRouteTable
Get-WmiObject Win32_IP4PersistedRouteTable | foreach-object {
    if ($_.Destination -eq "192.128.112.0"){$BackendGW = $_.Nexthop}
    }
if($lastexitcode -ne '0'){exit $ErrorLevel}

if ($BackendGW -eq $NULL) {exit $ErrorLevel}

Route add -p 10.1.1.0 mask 255.255.255.0 $BackendGW
if($lastexitcode -ne '0'){exit $ErrorLevel}
Route add -p 10.2.2.0 mask 255.255.255.0 $BackendGW
if($lastexitcode -ne '0'){exit $ErrorLevel}
Route add -p 10.3.3.0 mask 255.255.255.0 $BackendGW
if($lastexitcode -ne '0'){exit $ErrorLevel}
Route add -p 10.4.4.0 mask 255.255.255.0 $BackendGW
if($lastexitcode -ne '0'){exit $ErrorLevel}

exit $ErrorLevel
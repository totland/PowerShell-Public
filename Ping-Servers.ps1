clear-host
Set-Location $PSScriptRoot  # CD to the same directory as script
$ServerList = get-content $PSScriptRoot\Ping-server.txt
$collection = $()
foreach ($server in $ServerList)
{
    $status = @{ "ServerName" = $server; "TimeStamp" = (Get-Date -f s) }
    if (Test-Connection $server -Count 1 -ea 0 -Quiet)
    { 
        $status["Results"] = "Up"
        $srvos = "" | select-object os
        $srvos.OS = $OSInfo.Caption
        $status["OS"] = $srvOS
    } 
    else 
    { 
        $status["Results"] = "Down" 
    }
    New-Object -TypeName PSObject -Property $status -OutVariable serverStatus
    $collection += $serverStatus

}
$collection | Export-Csv -LiteralPath .\Ping-Server-Status.csv -NoTypeInformation


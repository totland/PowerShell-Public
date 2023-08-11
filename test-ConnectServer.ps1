Set-Location $PSScriptRoot
$names = Get-content "test-ConnectServer.txt"

foreach ($name in $names){
    $name = $name + ".home.local"
    
  if (Test-Connection -ComputerName $name -Count 1 -ErrorAction SilentlyContinue){
    Write-Host "$name is up" -ForegroundColor Green
  }
  else{
    Write-Host "$name is down" -ForegroundColor Red
    ping -n 1 $name
  }
}

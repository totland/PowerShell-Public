<#
.SYNOPSIS
  This script will gather performance data from a VC server and export the information in a csv file.

.DESCRIPTION
  <Brief description of script>

.PARAMETER <Parameter_Name>
  vCenter Name
  Number of Days
  vCenter Account
  vCenter Account Password

.INPUTS
  vCenter Name, Number of Days, vCenter Account, vCenter Account Password.

.OUTPUTS
  CSV file stored in the script working directory and will be called "(Date)-PerformanceData-(ServerName).csv"

.NOTES
  Version:        1.0
  Author:         TJ Totland
  Creation Date:  2018-06-30
  Purpose/Change: Updated to template
  
.EXAMPLE
  .\Get-PerformanceData.ps1 ServerName 7 VMWareID password
#>
 param(    
    [Parameter(Mandatory=$True)]  
    [String]$VCServer,
    [Parameter(Mandatory=$True)] 
    [int]$Days,
    [Parameter(Mandatory=$False)] 
    [String]$AdminID,
    [Parameter(Mandatory=$False)] 
    [String]$AdminPW
) 

#Connect vCenter
#Add-PSSnapin VM*
Get-Module -Name VMware* -ListAvailable | Import-Module 
Connect-VIServer -server $VCServer -User $AdminID -Password $AdminPW

#Varaibles
$OutputCSV = ".\" + (get-date).tostring("yyyyMMdd") +"-PerformanceData-" + $VCServer + ".csv"
Set-Location $PSScriptRoot
$allvms = @()
$allhosts = @()
$Days = 7
$hosts = Get-VMHost
$vms = Get-Vm

foreach($vmHost in $hosts){
  $hoststat = "" | Select-Object HostName, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin, DiskMax, DiskAvg, DiskMin, NetMax, NetAvg, NetMin
  $hoststat.HostName = $vmHost.name
  
  $statcpu =  Get-Stat -Entity ($vmHost) -Start (get-date).AddDays(-$Days) -Finish (get-date) -MaxSamples 10000 -stat cpu.usage.average
  $statmem =  Get-Stat -Entity ($vmHost) -Start (get-date).AddDays(-$Days) -Finish (get-date) -MaxSamples 10000 -stat mem.usage.average
  $statdisk = Get-Stat -Entity ($vmHost) -Start (get-date).AddDays(-$Days) -Finish (get-date) -MaxSamples 10000 -stat disk.usage.average
  $statnet =  Get-Stat -Entity ($vmHost) -Start (get-date).AddDays(-$Days) -Finish (get-date) -MaxSamples 10000 -stat net.usage.average
  
  $cpu = $statcpu | Measure-Object -Property value -Average -Maximum -Minimum
  $mem = $statmem | Measure-Object -Property value -Average -Maximum -Minimum
  $disk = $statdisk | Measure-Object -Property value -Average -Maximum -Minimum
  $net = $statnet | Measure-Object -Property value -Average -Maximum -Minimum
  
  $hoststat.CPUMax = [System.Math]::Round($cpu.Maximum)
  $hoststat.CPUAvg = [System.Math]::Round($cpu.Average)
  $hoststat.CPUMin = [System.Math]::Round($cpu.Minimum)
  $hoststat.MemMax = [System.Math]::Round($mem.Maximum)
  $hoststat.MemAvg = [System.Math]::Round($mem.Average)
  $hoststat.MemMin = [System.Math]::Round($mem.Minimum)
  $hoststat.DiskMax = [System.Math]::Round($disk.Maximum)
  $hoststat.DiskAvg = [System.Math]::Round($disk.Average)
  $hoststat.DiskMin = [System.Math]::Round($disk.Minimum)
  $hoststat.NetMax = [System.Math]::Round($net.Maximum)
  $hoststat.NetAvg = [System.Math]::Round($net.Average)
  $hoststat.NetMin = [System.Math]::Round($net.Minimum)
  
  $allhosts += $hoststat
}

$allhosts | Select-Object HostName, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin, DiskMax, DiskAvg, DiskMin, NetMax, NetAvg, NetMin  | Export-Csv $OutputCSV -noTypeInformation
$allhosts | Select-Object HostName, MemAvg, CPUAvg, DiskAvg, NetAvg | Format-Table

DisConnect-VIServer -server $VCServer -confirm:$false

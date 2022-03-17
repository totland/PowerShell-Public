#  Currently Not working, in draft mode
function Get-FolderSize {
    param ( [Parameter(Mandatory=$true)] [System.String]${Path} )
    
    $objFSO = New-Object -com  Scripting.FileSystemObject
    $folders = (Get-ChildItem $path | Where-Object {$_.PSIsContainer -eq $True})
    # Connect remotely
    # $folders = Invoke-Command "localhost" -FilePath C:\Users\TJTotland\OneDrive\Code\Powershell\Get-FolderSize.ps1 -ArgumentList "c:\users"

    Set-Location $PSScriptRoot

    foreach ($folder in $folders) {
        $folder | Add-Member -MemberType NoteProperty -Name "SizeMB" -Value (($objFSO.GetFolder($folder.FullName).Size) / 1MB) -PassThru
        }
}
Get-FolderSize $args[0]

$folders | Sort-Object -Property SizeMB -Descending | Select-Object fullname,@{n='SizeMBN2';e={"{0:N2}" -f $_.SizeMB}} | Select-Object -First 10

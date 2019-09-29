Import-Module $PSScriptRoot\UniversalDashboard.psm1

$Colors = @{
    BackgroundColor = "#8b2635"
    FontColor = "#fbfef9"
}

$AlternateColors = @{
    BackgroundColor = "#2e3532"
    FontColor = "#fcfcfc"
}

$ScriptColors = @{
    BackgroundColor = "#799496"
    FontColor = "#fcfcfc"
}

$Link = New-UDLink -Text 'Pensworth Website' -Url 'http://www.pensworth.co.uk' -Icon building_o

$Footer = New-UDFooter -Copyright 'Designed by Adam Bacon' -Links $Link

$NavBarLinks = @((New-UDLink -Text "Log a support call" -Url "https://pensworth.zendesk.com" -Icon medkit))


$HomeP = New-UDPage -Name "EDI Log Files" -Icon heart -Content {

New-UDLayout -Columns 6 -Content {

New-UDCard -Title "Log File $((get-date).AddDays(-6).ToShortDateString())" -BackgroundColor "#fcfcfc" -TextSize Medium -Content {

$date6 = (Get-Date).AddDays(-6).ToString('yyyy-MM-dd')
$log6 = Write-Host "Log File $((get-date).AddDays(-6).ToShortDateString())"
$l6name = "UnattendedImport.$date6.log"
$path6 = "\\REMOTE_SQL_SERVER\c$\Roundsman Enterprise\RoundsmanUnattendedImportService\logs\$l6name"
if (Test-Path $path6) {$f6 = gci "$path6" | Select Name,@{Name="Kilobytes";Expression={[math]::round($_.Length/1kb)}} }
else {$f6 = "Not Found"}
if ($f6 -match "Not Found")
{New-UDParagraph -Text "$($f6)" -Color "#8b2635"}
else
{New-UDParagraph -Text "$($f6.Kilobytes)KB" -Color "Green"}

}

New-UDCard -Title "Log File $((get-date).AddDays(-5).ToShortDateString())" -BackgroundColor "#fcfcfc" -TextSize Medium -Content {
$date5 = (Get-Date).AddDays(-5).ToString('yyyy-MM-dd')
$log5 = Write-Host "Log File $((get-date).AddDays(-5).ToShortDateString())"
$l5name = "UnattendedImport.$date5.log"
$path5 = "\\REMOTE_SQL_SERVER\c$\Roundsman Enterprise\RoundsmanUnattendedImportService\logs\$l5name"
if (Test-Path $path5) {$f5 = gci "$path5" | Select Name,@{Name="Kilobytes";Expression={[math]::round($_.Length/1kb)}} }
else {$f5 = "Not Found"}
if ($f5 -match "Not Found")
{New-UDParagraph -Text "$($f5)" -Color "#8b2635"}
else
{New-UDParagraph -Text "$($f5.Kilobytes)KB" -Color "Green"}

}

New-UDCard -Title "Log File $((get-date).AddDays(-4).ToShortDateString())" -BackgroundColor "#fcfcfc" -TextSize Medium -Content {

$date4 = (Get-Date).AddDays(-4).ToString('yyyy-MM-dd')
$log4 = Write-Host "Log File $((get-date).AddDays(-4).ToShortDateString())"
$l4name = "UnattendedImport.$date4.log"
$path4 = "\\REMOTE_SQL_SERVER\c$\Roundsman Enterprise\RoundsmanUnattendedImportService\logs\$l4name"
if (Test-Path $path4) {$f4 = gci "$path4" | Select Name,@{Name="Kilobytes";Expression={[math]::round($_.Length/1kb)}} }
else {$f4 = "Not Found"}
if ($f4 -match "Not Found")
{New-UDParagraph -Text "$($f4)" -Color "#8b2635"}
else
{New-UDParagraph -Text "$($f4.Kilobytes)KB" -Color "Green"}
#}}
}

New-UDCard -Title "Log File $((get-date).AddDays(-3).ToShortDateString())" -BackgroundColor "#fcfcfc" -TextSize Medium -Content {
$date3 = (Get-Date).AddDays(-3).ToString('yyyy-MM-dd')
$log3 = Write-Host "Log File $((get-date).AddDays(-3).ToShortDateString())"
$l3name = "UnattendedImport.$date3.log"
$path3 = "\\REMOTE_SQL_SERVER\c$\Roundsman Enterprise\RoundsmanUnattendedImportService\logs\$l3name"
if (Test-Path $path3) {$f3 = gci "$path3" | Select Name,@{Name="Kilobytes";Expression={[math]::round($_.Length/1kb)}} }
else {$f3 = "Not Found"}
if ($f3 -match "Not Found")
{New-UDParagraph -Text "$($f3)" -Color "#8b2635"}
else
{New-UDParagraph -Text "$($f3.Kilobytes)KB" -Color "Green"}

}

New-UDCard -Title "Log File $((get-date).AddDays(-2).ToShortDateString())" -BackgroundColor "#fcfcfc" -TextSize Medium -Content {

$date2 = (Get-Date).AddDays(-2).ToString('yyyy-MM-dd')
$log2 = Write-Host "Log File $((get-date).AddDays(-2).ToShortDateString())"
$l2name = "UnattendedImport.$date2.log"
$path2 = "\\REMOTE_SQL_SERVER\c$\Roundsman Enterprise\RoundsmanUnattendedImportService\logs\$l2name"
if (Test-Path $path2) {$f2 = gci "$path2" | Select Name,@{Name="Kilobytes";Expression={[math]::round($_.Length/1kb)}} }
else {$f2 = "Not Found"}
if ($f2 -match "Not Found")
{New-UDParagraph -Text "$($f2)" -Color "#8b2635"}
else
{New-UDParagraph -Text "$($f2.Kilobytes)KB" -Color "Green"}

}

New-UDCard -Title "Log File $((get-date).AddDays(-1).ToShortDateString())" -BackgroundColor "#fcfcfc" -TextSize Medium -Content {
$date1 = (Get-Date).AddDays(-1).ToString('yyyy-MM-dd')
$log1 = Write-Host "Log File $((get-date).AddDays(-1).ToShortDateString())"
$l1name = "UnattendedImport.$date1.log"
$path1 = "\\REMOTE_SQL_SERVER\c$\Roundsman Enterprise\RoundsmanUnattendedImportService\logs\$l1name"
if (Test-Path $path1) {$f1 = gci "$path1" | Select Name,@{Name="Kilobytes";Expression={[math]::round($_.Length/1kb)}} }
else {$f1 = "Not Found"}
if ($f1 -match "Not Found")
{New-UDParagraph -Text "$($f1)" -Color "#8b2635"}
else
{New-UDParagraph -Text "$($f1.Kilobytes)KB" -Color "Green"}
#}}
}
}
New-UDRow -Columns {
New-UDColumn -Size 6 -Content {
   New-UDCard -Content {
   New-UdMonitor -Title "FTP Imported Files" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63' -Width 2 -Endpoint {
    (gci "\\REMOTE_SQL_SERVER\EDI_ORDERS\Monitor").count  | Out-UDMonitorData
}
}
        }

New-UDColumn -Size 3 -Content {
            New-UDCounter -Title "Total Imported Orders" -AutoRefresh -RefreshInterval 3 -Format "0,0" -Icon bars -TextSize Medium @ScriptColors -TextAlignment center -Endpoint {
            (gci \\REMOTE_SQL_SERVER\EDI_ORDERS\Archive).count
            }

            New-UDCounter -Title "Log File $((get-date).ToShortDateString()) in KB" -AutoRefresh -RefreshInterval 3 -Format "0,0" -Icon bomb -TextSize Medium @ScriptColors -TextAlignment center -Endpoint  {
$date2day = (Get-Date).ToString('yyyy-MM-dd')
$lname = "UnattendedImport.$date2day.log"
$path2day = "\\REMOTE_SQL_SERVER\c$\Roundsman Enterprise\RoundsmanUnattendedImportService\logs\$lname"
            [math]::Round((gci "$path2day").Length / 1kb)
            }
#            }
            }
New-UDColumn -Size 3 -Content {
            New-UDCounter -Title "Total EDI Orders Today" -AutoRefresh -RefreshInterval 3 -Format "0,0" -Icon angellist -TextSize Medium @ScriptColors -TextAlignment center -Endpoint {
            (gci \\REMOTE_SQL_SERVER\EDI_ORDERS\Archive | ? {$_.LastAccessTime -gt (Get-Date).Date}).count
            }

           New-UDRow -Columns {
       New-UDTable -Title "RM Service" -Headers @("DisplayName", "Status") -AutoRefresh -RefreshInterval 5 -Endpoint {
       get-service -ComputerName REMOTE_SQL_SERVER | ? {$_.DisplayName -match 'Roundsman Unattended'} | Out-UDTableData -Property @("DisplayName", "Status")
       }

           }


}
New-UDColumn -Size 4 -Content {
New-UDRow -Columns {
New-UDTable -Title "Jobs" -Headers @("TaskName", "LastTaskResult") -AutoRefresh -RefreshInterval 5 -Endpoint {
       Get-ScheduledTaskInfo -TaskPath '\Microsoft\Windows\PowerShell\ScheduledJobs\' -TaskName 'PoundlandOrders' | Out-UDTableData -Property @("TaskName", "LastTaskResult")
       Get-ScheduledTaskInfo -TaskPath '\Microsoft\Windows\PowerShell\ScheduledJobs\' -TaskName 'PoundlandOrdersEmail' | Out-UDTableData -Property @("TaskName", "LastTaskResult")
       Get-ScheduledTaskInfo -TaskPath '\Microsoft\Windows\PowerShell\ScheduledJobs\' -TaskName 'RadishOrders' | Out-UDTableData -Property @("TaskName", "LastTaskResult")
       Get-ScheduledTaskInfo -TaskPath '\Microsoft\Windows\PowerShell\ScheduledJobs\' -TaskName 'RadishOrdersEmail' | Out-UDTableData -Property @("TaskName", "LastTaskResult")
       }
}
  }
}
}



$Dashb = New-UDDashboard -NavBarLogo $logo -NavbarLinks $NavBarLinks -NavBarColor '#2e3532' -NavBarFontColor '#fcfcfc' -BackgroundColor '#8b2635' -Title "EDI Agency Dashboard" -Pages @(
$HomeP
#$Page2
) -Footer $Footer



Start-UDDashboard -Wait -Dashboard (
$Dashb
) #-Port 10001


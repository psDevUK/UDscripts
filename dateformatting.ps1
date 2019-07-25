import-module -name UniversalDashboard
Get-UDDashboard | Stop-UDDashboard
$testpage = New-UDPage -Name test -Content {

New-UDInput -Content {

    New-UDInputField -type 'date' -Name "Datep" -Placeholder "Date"
} -Endpoint {
    param($Datep)
   $var = get-date $Datep
   $DateFormat = $var.ToString('MM-dd-yyyy')
    New-UDInputAction -Toast $DateFormat -duration 2000
}
}

$Dashboard = New-UDDashboard -Title "Date Formatting" -Pages @(
    $testpage
)
Start-UDDashboard -Dashboard $Dashboard -Port 8094 -AutoReload

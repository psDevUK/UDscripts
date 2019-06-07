###Import the module if not imported already
Import-Module -Name UniversalDashboard
###Stop any running dashboards so no conflict with port numbers
Get-UDDashboard | Stop-UDDashboard
######## Set a schedule for the endpoint to run every xxx
$Schedule = New-UDEndpointSchedule -Every 5 -Second
####initialise the endpoint variable to load when the dashboard loads...you can include functions, and use the cache variable very important
$Endpoint = New-UDEndpoint -Schedule $Schedule -Endpoint {

    $Cache:process = Get-Process | select -first 6 | Out-UDTableData -Property @("name", "id")
    $Cache:service = Get-Service | select -first 6 | Out-UDTableData -Property @("DisplayName", "status")
}
$test = New-UDPage -Name 'Test' -Content {
    $Layout = '{"lg":[{"w":4,"h":10,"x":0,"y":0,"i":"grid-element-leftcard","moved":false,"static":false},{"w":7,"h":10,"x":4,"y":0,"i":"grid-element-table","moved":false,"static":false},{"w":1,"h":2,"x":11,"y":0,"i":"grid-element-icon1","moved":false,"static":false}]}'
    New-UDGridLayout -Layout $Layout -Content {

        New-UDCard -Id "leftcard" -Title "Sync Table" -TextSize Large -Endpoint {
            New-UDTextbox -Placeholder 'Process or Service' -Id 'txtTicker' -Icon question_circle
            New-UDButton -Id 'btnSearch' -Text 'Search' -Icon search -IconAlignment 'left' -OnClick {
                $Session:Ticker = (Get-UDElement -Id 'txtTicker').Attributes['value']
                @("table") | Sync-UDElement
            }
        }
           New-UDTable -Id "table" -Title "Computer Information" -Headers @(" ", " ") -AutoRefresh -Endpoint {
            if ($Session:Ticker -eq $null) {
                    $Session:Ticker = "process"
                }
                elseif ($Session:Ticker -match 'service') { $Cache:service }
                elseif ($Session:Ticker -match 'process') { $Cache:process }
                else { Show-UDToast -Message "You can only type process or service try again" -Duration 30000 }
            } -RefreshInterval 5
            New-UDIcon -Color "#7ed321" -Icon "question" -Id "icon1" -Size "5x"
        }
    }

$Dashboard = New-UDDashboard -Title "Table Sync Demo" -Pages @(
    $test
)
####START THE DASHBOARD AND CALL YOUR ENDPOINT TO BE INCLUDED FROM HERE
Start-UDDashboard -Dashboard $Dashboard -Port 8091 -Endpoint $Endpoint
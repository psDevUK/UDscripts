###Import the module if not imported already
Import-Module -Name UniversalDashboard
###Stop any running dashboards so no conflict with port numbers
Get-UDDashboard | Stop-UDDashboard
$theme = New-UDTheme -Name "Basic" -Definition @{
    UDNavBar = @{
        BackgroundColor = "black"
        FontColor       = "white"
    }
    UDFooter = @{
         BackgroundColor = "black"
        FontColor       = "white"
    }
}
    $Layout    = '{"lg":[{"w":1,"h":2,"x":5,"y":0,"i":"grid-element-icon","moved":false,"static":false}]}'
    $test      = New-UDPage -Name 'Test' -Content {
        New-UDGridLayout -Layout $Layout -Content {

            New-UDIcon -Color "#d0021b" -Icon "laptop" -Id "icon" -Size "5x"
        }
    }
    $Dashboard = New-UDDashboard -Title "BlackNavBar" -Pages @(
        $test
    ) -Theme $theme
    Start-UDDashboard -Dashboard $Dashboard -Port 8091
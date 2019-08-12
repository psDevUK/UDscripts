###import module ready to use
Import-Module -Name UniversalDashboard.Community
###get and stop any existing dashboards so no conflict with port numbers
Get-UDDashboard | Stop-UDDashboard
###Set your endpoint and how often you want your cached variables inside the endpoint update
$Schedule = New-UDEndpointSchedule -Every 60 -Second
####initialise the endpoint variable to load when the dashboard loads...you can include functions, and use the cache variable very important
$Endpoint = New-UDEndpoint -Schedule $Schedule -Endpoint {
    $Cache:files = Get-ChildItem $ENV:HOMEDRIVE | Select-Object Name | Export-csv $ENV:HOMEDRIVE\files.csv -NoTypeInformation
}

##Get Ready for the dashboard
$NavBarLinks = @((New-UDLink -Text "Visit My Website" -Url "https://wwww.yoursite.com" -Icon medkit))
$Link = New-UDLink -Text 'Company Website' -Url 'http://www.yourcompany.com' -Icon globe
$Footer = New-UDFooter -Copyright 'Designed by Your Name' -Links $Link
$theme = New-UDTheme -Name "Azure" -Definition @{
    UDDashboard = @{
        BackgroundColor = "#333333"
        FontColor = "#FFFFF"
    }
    UDNavBar = @{
        BackgroundColor = "#1c1c1c"
        FontColor = "#55b3ff"
    }
    UDCard = @{
        BackgroundColor = "#252525"
        FontColor = "#FFFFFF"
    }
    UDChart = @{
        BackgroundColor = "#252525"
        FontColor = "#FFFFFF"
    }
    UDMonitor = @{
        BackgroundColor = "#252525"
        FontColor = "#FFFFFF"
    }
    UDTable = @{
        BackgroundColor = "#252525"
        FontColor = "#FFFFFF"
    }
    UDGrid = @{
        BackgroundColor = "#252525"
        FontColor = "#FFFFFF"
    }
    UDCounter = @{
        BackgroundColor = "#252525"
        FontColor = "#FFFFFF"
    }
    UDInput = @{
        BackgroundColor = "#252525"
        FontColor = "#FFFFFF"
    }
    UDFooter = @{
        BackgroundColor = "#1c1c1c"
        FontColor = "#55b3ff"
    }
    '.tabs .tab' = @{
        'color' = "#252525"
        }

        '.tabs .tab a:hover'                                                                                                            = @{
            'background-color' = "#252525"
            'color'            = "#55b3ff"
        }

        '.tabs .tab a.active'                                                                                                           = @{
            'background-color' = "#1c1c1c"
            'color'            = "#55b3ff"
        }
        '.tabs .tab a:focus.active'                                                                                                     = @{

        'background-color' = "#252525"
        'color' = "#55b3ff"
        }
        '.tabs .indicator' = @{
        'background-color' = "#55b3ff"
        }
        '.tabs .tab a' = @{
        'color' = "#FFFFFF"
        }
        '.tabs' = @{
            'background-color' = "#333333"
        }
}
$Homep = New-UDPage -Name "Home Page" -Icon home -Content {
    New-UDTabContainer -Tabs {
        New-UDTab -Text "HOME" -Content {
    $Layout = '{"lg":[{"w":8,"h":12,"x":0,"y":0,"i":"grid-element-left","moved":false,"static":false},{"w":3,"h":7,"x":8,"y":0,"i":"grid-element-right","moved":false,"static":false}]}'
    New-UDGridLayout -Layout $Layout -Content {
        New-UDMonitor -Id "left" -Title "Number of files on $ENV:HOMEDRIVE" -Type Line -Endpoint {
            $csvcount = Import-Csv $ENV:HOMEDRIVE\files.csv
            $csvcount.Name.count | Out-UDMonitorData
        }
        New-UDCounter -Id "right" -Title "Files on $ENV:HOMEDRIVE" -Icon calculator -Endpoint {
            $csvcount = Import-Csv $ENV:HOMEDRIVE\files.csv
            $csvcount.Name.count
        }
    }
}
New-UDTab -Text "TEST" -Content {}


}
}

$dashboard = New-UDDashboard -Title "Montior Counter Demo" -Pages (
    $Homep
) -NavbarLinks $NavBarLinks -Footer $Footer -Theme $theme
Start-UDDashboard -Dashboard $dashboard -Port 8091 -Name DemoDashboard -AutoReload -Endpoint $Endpoint

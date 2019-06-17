###Import the module if not imported already
Import-Module -Name UniversalDashboard
###Stop any running dashboards so no conflict with port numbers
Get-UDDashboard | Stop-UDDashboard
$Root = $PSScriptRoot
$Initialization = New-UDEndpointInitialization -Variable "Root"
$HomePage = New-UDPage -Name 'CSV To Chart' -Content {
    $Layout = '{"lg":[{"w":8,"h":8,"x":0,"y":0,"i":"grid-element-topLeft","moved":false,"static":false},{"w":8,"h":9,"x":0,"y":8,"i":"grid-element-BottomLeft","moved":false,"static":false},{"w":4,"h":17,"x":8,"y":0,"i":"grid-element-grid","moved":false,"static":false}]}'
    New-UDGridLayout -Layout $Layout -Content {
        New-UDChart -Id "topLeft" -Type Bar -Endpoint {
            $csv = import-csv $Root\test.csv
            $csv | Select-Object "WhenCreated", "DistinguishedName", "Enabled" | Out-UDChartData -LabelProperty "WhenCreated" -Dataset @(
                New-UDChartDataset -DataProperty "DistinguishedName" -Label "Name" -BackgroundColor "#5fad56"
                New-UDChartDataset -DataProperty "Enabled" -Label "Enabled" -BackgroundColor "#279af1"

            )
        } -Labels @("WhenCreated") -Options @{
            scales = @{
                xAxes = @(
                    @{
                        stacked = $true
                    }
                )
                yAxes = @(
                    @{
                        stacked = $true
                    }
                )
            }
        }
        New-UDChart -Id "BottomLeft" -Type Line -Endpoint {
            $csv = import-csv $Root\test.csv
            $csv | Select-Object "WhenCreated", "DistinguishedName", "Enabled" | Out-UDChartData -LabelProperty "DistinguishedName" -Dataset @(
                New-UDChartDataset -DataProperty "Enabled" -Label "Enabled" -BackgroundColor "#b2ffa9" -HoverBackgroundColor "#3f2a2b"
            )
            }

        New-UDGrid -Id "grid" -Title "CSV Demo" -Headers @("WhenCreated", "DistinguishedName", "Enabled") -Properties @("WhenCreated", "DistinguishedName", "Enabled") -DefaultSortColumn "WhenCreated" -DefaultSortDescending -Endpoint {
            $csv = import-csv $Root\test.csv
            $csv | Select-Object "WhenCreated", "DistinguishedName", "Enabled" | Out-UDGridData
        }
    }
}
$Dashboard = New-UDDashboard -Title "CSV TO CHARTS DEMO" -Pages @(
    $HomePage
) -NavBarLogo (New-UDImage -Url "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&ved=2ahUKEwiX58mojvHiAhVDz4UKHTnrCGIQjRx6BAgBEAU&url=http%3A%2F%2Fclipartmag.com%2Fironman-logo&psig=AOvVaw2gljZv70LJ8aooE_zq4kjM&ust=1560881355487256") -NavBarColor "#4392f1" -NavBarFontColor "#000000" -EndpointInitialization $Initialization
Start-UDDashboard -Dashboard $Dashboard -Port 8091  -AutoReload
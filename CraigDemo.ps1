### Import module ready to create dashboard page
## Using community version as on personal laptop and find build 2.8.1 good stable build
Import-Module -Name UniversalDashboard.Community -RequiredVersion 2.8.1
##For testing purposes when building this page I will be reloading I want the most recent version showing so I run
Get-UDDashboard | Stop-UDDashboard
##Get ready to build dashboard by defining the port to run this on locally
Start-UDDashboard -Port 10006 -Dashboard (
    ###Now lets give the dashboard a title
    New-UDDashboard -Title "Demo For Craig" -Content {
        ## Going to try and mimic the layout of your dashboard
        New-UDRow -Columns {
            ## So having a title and a selection list and a checkbox
            #Needed to do this first column as just the selection list, else the BADCount session data didnt pass correctly
            New-UDColumn -Id "TopColumn" -Size 4 -Endpoint {
                New-UDHeading -Size 3 -Text "Select A Process"
                # Setting up a select list to select processes running A to D or E to H etc...
                New-UDSelect -Label "Select the letters of processes running" -Option {
                    New-UDSelectOption -Name "Make Selection" -Value 99
                    New-UDSelectOption -Name "A-D" -Value 1
                    New-UDSelectOption -Name "E-H" -Value 2
                } -OnChange {
                    #So once the selection is made this will store the value in $EventData I will store
                    # this in a session variable to display the table output on, remembering to sync the tables and columns you want this data passed to
                    $Session:Selected = $EventData
                    @('TableColumn', 'TableAD', 'TableEH', 'TextRefresh') | Sync-UDElement
                }
            } -RefreshInterval 4
            New-UDColumn -Id "TextRefresh" -size 5 -Endpoint {
                #this needed to be in it's own column to obtain the count of all the badcount session variable correctly
                #obviously as this is demo I am not that bothered about formatting nice layout it is proof of concept that matters here
                if ($Session:BadCount -gt 1) {
                    New-UDHeading -Size 6 -Text "There have been $($Session:BadCount) duplicate names found"
                }
            } -RefreshInterval 3
            # New-UDColumn -Id "CheckBox" -Endpoint {
            #     if ($Session:BadCount -gt 1) {
            #         New-UDSwitch -Id "Switch" -OnText "Fix Problems" -OffText "Dont Fix" -OnChange {
            #             $Session:Fixit = $EventData
            #             @('TableColumn', 'TableADFixed') | Sync-UDElement
            #         }
            #     }
            # } -RefreshInterval 4
            New-UDColumn -Id "TableColumn" -size 12 -Endpoint {
                If ($Session:Selected -eq 1) {
                    New-UDTable -Id "TableAD" -Title "Process Ids" -Header @("Name", "Process Id", "Icon") -Endpoint {

                        $Data = @(get-process | ? { $_.ProcessName -match '^A|^B|^C|^D' } | Select name, ID)
                        $UniqueData = @($Data | sort -Unique Name | select -ExpandProperty ID)
                        $Data | ForEach-Object {
                            $Current = $_ | Select -ExpandProperty ID
                            if ( $Current -in $UniqueData) {
                                [PSCustomObject]@{
                                    Name = $_.Name
                                    ID   = $_.ID
                                    Icon = New-UDIcon -Icon check_square -Color 'Green'
                                }
                            }
                            else {
                                [PSCustomObject]@{
                                    Name = $_.Name
                                    ID   = $_.ID
                                    Icon = New-UDIcon -Icon times_rectangle -Color 'Red'
                                }
                            }
                        } | Out-UDTableData -Property @("name", "id", "Icon")
                        $Session:BadCount = ($Data).Count - ($UniqueData).Count
                        @('Topcolumn', 'TextRefresh', 'CheckBox') | Sync-UDElement
                    } -RefreshInterval 4
                }

                If ($Session:Selected -eq 2) {
                    New-UDTable -Id "TableEH" -Title "Process Ids" -Header @("Name", "Process Id", "Icon") -Endpoint {

                        $Data = @(get-process | ? { $_.ProcessName -match '^E|^F|^G|^H' } | Select name, ID)
                        $UniqueData = @($Data | sort -Unique Name | select -ExpandProperty ID)
                        $Data | ForEach-Object {
                            $Current = $_ | Select -ExpandProperty ID
                            if ( $Current -in $UniqueData) {
                                [PSCustomObject]@{
                                    Name = $_.Name
                                    ID   = $_.ID
                                    Icon = New-UDIcon -Icon check_square -Color 'Green'
                                }
                            }
                            else {
                                [PSCustomObject]@{
                                    Name = $_.Name
                                    ID   = $_.ID
                                    Icon = New-UDIcon -Icon times_rectangle -Color 'Red'
                                }
                            }
                        } | Out-UDTableData -Property @("name", "id", "Icon")
                        $Session:BadCount = ($Data).Count - ($UniqueData).Count
                        @('TopColumn', 'TextRefresh', 'CheckBox') | Sync-UDElement
                    } -RefreshInterval 4
                }
            }
        }
    }
)

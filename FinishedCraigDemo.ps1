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
                    @('TableColumn', 'TableAD', 'TableEH', 'TextRefresh', 'TableUnfix') | Sync-UDElement
                }
            } -RefreshInterval 4
            New-UDColumn -Id "TextRefresh" -size 5 -Endpoint {
                #this needed to be in it's own column to obtain the count of all the badcount session variable correctly
                #obviously as this is demo I am not that bothered about formatting nice layout it is proof of concept that matters here
                if ($Session:BadCount -gt 1) {
                    #just to move this UDHeading down the page a bit add a paragraph and break return
                    New-UDHtml -Markup "<p><br></p>"
                    New-UDHeading -Size 6 -Text "There have been $($Session:BadCount) duplicate names found"
                    #now the above is in-line with the title
                    #Lets remember to sync the control to now show
                    @('CheckBox') | Sync-UDElement
                }
                #on bigger databases, and more endpoints might need to give a bit more on your refresh interval
                #this is checking every 3 seconds for changes
            } -RefreshInterval 5
            #Adding another column to store a switch component in to fix the issues, so we only get unique process names
            #Apply your method but again for demo propses this is what you wanted I believe
            New-UDColumn -Id "CheckBox" -Endpoint {
                #So if the message appears there is bad items in the list we want the checkbox or switch in this case to appear
                if ($Session:BadCount -gt 1) {
                    #lets align this with the text in the olther column so it looks aligned
                    New-UDHtml -Markup "<p><br></p>"
                    #I always give components I want to interact with a ID name so you can use get-udelement to reference the attribute value of it
                    New-UDSwitch -Id "Switch" -OnText "Fix Problems" -OffText "Dont Fix" -OnChange {
                        $EventData
                        $Session:Fixit = $EventData
                        #Remember to sync the changes with other components on the page that you need to pass this session variable to
                        @('TableColumn', 'TableADFix', 'TableAD', 'TableEH', 'TableEHFix', 'TableUnfix') | Sync-UDElement
                    }
                }
            } -RefreshInterval 4
            New-UDColumn -Id "TableColumn" -size 12 -Endpoint {
                #So this is where we make the result section appear or disappear depending on the criteria of the Session variables held
                #This first section will verify that option 1 was selected and the switch to fix it has not been applied
                #Notice how you can call the refresh on the table endpoint
                If ($Session:Selected -eq 1 -and $Session:Fixit -match 'False') {
                    New-UDTable -Id "TableUnfix" -Title "Process Ids" -Header @("Name", "Process Id", "Icon") -Endpoint {

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
                        @('Topcolumn', 'TextRefresh') | Sync-UDElement
                    } -RefreshInterval 4
                }
                ##adding this as i obviously couldnt think of a good enough solution in my if statement...thinking a button would be better
                If ($Session:Selected -eq 1 -and $Session:Fixit -ne 'True') {
                    New-UDTable -Id "TableUnfix" -Title "Process Ids" -Header @("Name", "Process Id", "Icon") -Endpoint {

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
                        @('Topcolumn', 'TextRefresh') | Sync-UDElement
                    } -RefreshInterval 4
                }
                #So now we want to check if the fix has been applied and if it has what results it should display
                if ($Session:Fixit -eq 'True' -and $Session:Selected -eq 1) {
                    New-UDTable -Id "TableADFix" -Title "Process Ids" -Header @("Name", "Process Id", "Icon") -Endpoint {
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
                        } | Out-UDTableData -Property @("name", "id", "Icon")
                        $Session:BadCount = 0
                        @('Topcolumn', 'TextRefresh') | Sync-UDElement
                    } -RefreshInterval 4
                    # Again setting the refresh of this component on the endpoint of the table
                }

                #So now I am going to apply the same method to the rest of my selections, give them a criteria to meet to display the data
                If ($Session:Selected -eq 2 -and $Session:Fixit -ne 'True') {
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
                        @('TopColumn', 'TextRefresh') | Sync-UDElement
                    } -RefreshInterval 4
                }
                #last if statement for this demo dashboard horray remembering to meet the session variables
                if ($Session:Fixit -eq 'True' -and $Session:Selected -eq 2) {
                    #Remember to give all your unique tables unique ids
                    New-UDTable -Id "TableEHFix" -Title "Process Ids" -Header @("Name", "Process Id", "Icon") -Endpoint {
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
                        } | Out-UDTableData -Property @("name", "id", "Icon")
                        $Session:BadCount = 0
                        @('Topcolumn', 'TextRefresh') | Sync-UDElement
                    } -RefreshInterval 4
                    # Again setting the refresh of this component on the endpoint of the table
                }
            }
        }
    }
)

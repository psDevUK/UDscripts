###Import the module if not imported already
Import-Module -Name UniversalDashboard
###Stop any running dashboards so no conflict with port numbers
Get-UDDashboard | Stop-UDDashboard
######## Set a schedule for the endpoint to run every xxx
$Schedule = New-UDEndpointSchedule -Every 60 -Second
####initialise the endpoint variable to load when the dashboard loads...you can include functions, and use the cache variable very important
$Endpoint = New-UDEndpoint -Schedule $Schedule -Endpoint {
    function Invoke-Sqlcmd2 {
        [CmdletBinding()]
        param (
            [Parameter(Position = 0, Mandatory = $true)]
            [string]$ServerInstance,
            [Parameter(Position = 1, Mandatory = $false)]
            [string]$Database,
            [Parameter(Position = 2, Mandatory = $false)]
            [string]$Query,
            [Parameter(Position = 3, Mandatory = $false)]
            [string]$Username,
            [Parameter(Position = 4, Mandatory = $false)]
            [string]$Password,
            [Parameter(Position = 5, Mandatory = $false)]
            [Int32]$QueryTimeout = 600,
            [Parameter(Position = 6, Mandatory = $false)]
            [Int32]$ConnectionTimeout = 15,
            [Parameter(Position = 7, Mandatory = $false)]
            [ValidateScript( { test-path $_ })]
            [string]$InputFile,
            [Parameter(Position = 8, Mandatory = $false)]
            [ValidateSet("DataSet", "DataTable", "DataRow")]
            [string]$As = "DataRow"
        )

        if ($InputFile) {
            $filePath = $(resolve-path $InputFile).path
            $Query = [System.IO.File]::ReadAllText("$filePath")
        }

        $conn = new-object System.Data.SqlClient.SQLConnection

        if ($Username)
        { $ConnectionString = "Server={0};Database={1};User ID={2};Password={3};Trusted_Connection=False;Connect Timeout={4}" -f $ServerInstance, $Database, $Username, $Password, $ConnectionTimeout }
        else
        { $ConnectionString = "Server={0};Database={1};Integrated Security=True;Connect Timeout={2}" -f $ServerInstance, $Database, $ConnectionTimeout }

        $conn.ConnectionString = $ConnectionString

        #Following EventHandler is used for PRINT and RAISERROR T-SQL statements. Executed when -Verbose parameter specified by caller
        if ($PSBoundParameters.Verbose) {
            $conn.FireInfoMessageEventOnUserErrors = $true
            $handler = [System.Data.SqlClient.SqlInfoMessageEventHandler] { Write-Verbose "$($_)" }
            $conn.add_InfoMessage($handler)
        }

        $conn.Open()
        $cmd = new-object system.Data.SqlClient.SqlCommand($Query, $conn)
        $cmd.CommandTimeout = $QueryTimeout
        $ds = New-Object system.Data.DataSet
        $da = New-Object system.Data.SqlClient.SqlDataAdapter($cmd)
        [void]$da.fill($ds)
        $conn.Close()
        switch ($As) {
            'DataSet' { Write-Output ($ds) }
            'DataTable' { Write-Output ($ds.Tables) }
            'DataRow' { Write-Output ($ds.Tables[0]) }
        }

    }
    ####WRITE YOUR OWN SQL QUERY HERE
    $queryActive = @"
SELECT V.Vehicle_ID
      ,H.Agreement
      ,UPPER(V.Registration) Registration
      ,V.Make
      ,W.Weight
      ,S.StatusName
      ,E.EngineType
      ,D.DepotName
      ,F.Round_Name
      ,A.Active
  FROM [FLEET].[dbo].[Vehicle] as V INNER JOIN
  FLEET.dbo.Hire as H ON V.Hire_ID = H.Hire_ID INNER JOIN
  FLEET.dbo.Weight as W ON V.Weight_ID = W.Weight_ID INNER JOIN
  FLEET.dbo.Status as S ON V.Status_ID = S.Status_ID INNER JOIN
  FLEET.dbo.EngineType as E ON V.Engine_ID = E.Engine_ID INNER JOIN
  FLEET.dbo.Active as A ON V.Active_ID = A.Active_ID INNER JOIN
  FLEET.dbo.Depot as D on V.Depot_ID = D.Depot_ID LEFT JOIN
  FLEET.dbo.FoodRound as F ON V.Vehicle_ID = F.Vehicle_ID
  WHERE Active = 'True'
"@
    ######MAKE SURE YOU PUT IN YOUR SQL SERVER AND YOUR USERNAME AND PASSWORD
    $Cache:ActiveV = Invoke-Sqlcmd2 -ServerInstance "YOURsqlSERVER" -Database "YOURDB" -Query $queryActive -Username YOUR_USERNAME -Password YOUR_PASSWORD



}
####CREATE THE PAGE TO HOST IT
$test = New-UDPage -Name 'Test' -Content {
    #####DESIGN YOUR OWN SUPER COOL LAYOUT USING UDPAGEDESIGNER
    $Layout = '{"lg":[{"w":1,"h":3,"x":0,"y":0,"i":"grid-element-icon1","moved":false,"static":false},{"w":10,"h":10,"x":1,"y":0,"i":"grid-element-grid","moved":false,"static":false}]}'
    ####CALL THE SUPER COOL LAYOUT IN THE GRIDLAYOUT CMDLET
    New-UDGridLayout -Layout $Layout -Content {
        New-UDIcon -Color "#b10f2e" -FixedWidth:$False -Icon "info" -Id "icon1" -Size "5x"
        ###SET THE GRID AND CALL THE QUERY YOU STORED IN THE ENDPOINT AT THE TOP OF THE PAGE THIS USES THE CACHE VARIABLE SCOPE
        New-UDGrid -Id "grid" -Title "Showing All Active Vehicles In The Database" -Headers @("Vehicle_ID", "Agreement", "Registration", "Make", "Weight", "StatusName", "EngineType", "DepotName", "Round_Name", "Active") -Properties @("Vehicle_ID", "Agreement", "Registration", "Make", "Weight", "StatusName", "EngineType", "DepotName", "Round_Name", "Active") -DefaultSortColumn "Vehicle_ID" -PageSize 7  -Endpoint {
            $Cache:ActiveV | Select-Object "Vehicle_ID", "Agreement", "Registration", "Make", "Weight", "StatusName", "EngineType", "DepotName", "Round_Name", "Active" | Out-UDGridData
        } -AutoRefresh -RefreshInterval 35

    }
}
###LOAD YOUR PAGES INTO A DASHBOARD TO DISPLAY
$Dashboard = New-UDDashboard -Title "Grid SQL Demo" -Pages @(
    $test
)
####START THE DASHBOARD AND CALL YOUR ENDPOINT TO BE INCLUDED FROM HERE
Start-UDDashboard -Dashboard $Dashboard -Port 8091 -Endpoint $Endpoint
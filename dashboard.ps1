###Adz COMPLAINTS Dashboard###
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
function Get-ADGroupMembers {
    <#
.SYNOPSIS
    Return all group members for specified groups.

.FUNCTIONALITY
    Active Directory

.DESCRIPTION
    Return all group members for specified groups.   Requires .NET 3.5, does not require RSAT

.PARAMETER Group
    One or more Security Groups to enumerate

.PARAMETER Recurse
    Whether to recurse groups.  Note that subgroups are NOT returned if this is true, only user accounts

    Default value is $True

.EXAMPLE
    #Get all group members in Domain Admins or nested subgroups, only include samaccountname property
    Get-ADGroupMembers "Domain Admins" | Select-Object -ExpandProperty samaccountname

.EXAMPLE
    #Get members for objects returned by Get-ADGroupMembers
    Get-ADGroupMembers -group "Domain Admins" | Get-Member
#>
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [string[]]$group = 'Domain Admins',

        [bool]$Recurse = $true
    )

    Begin {
        #Add the .net type
        $type = 'System.DirectoryServices.AccountManagement'
        Try {
            Add-Type -AssemblyName $type -ErrorAction Stop
        }
        Catch {
            Throw "Could not load $type`: Confirm .NET 3.5 or later is installed"
            Break
        }

        #set up context type
        # use the 'Machine' ContextType if you want to retrieve local group members
        # http://msdn.microsoft.com/en-us/library/system.directoryservices.accountmanagement.contexttype.aspx
        $ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain
    }

    Process {
        #List group members
        foreach ($GroupName in $group) {
            Try {
                $grp = [System.DirectoryServices.AccountManagement.GroupPrincipal]::FindByIdentity($ct, $GroupName)

                #display results or warn if no results
                if ($grp) {
                    $grp.GetMembers($Recurse)
                }
                else {
                    Write-Warning "Could not find group '$GroupName'"
                }
            }
            Catch {
                Write-Error "Could not obtain members for $GroupName`: $_"
                Continue
            }
        }
    }
    End {
        #cleanup
        $ct = $grp = $null
    }
}
###Import the module if not imported already
Import-Module "C:\inetpub\wwwroot\COMPLAINTS\UniversalDashboard.psm1"
Import-Module "C:\inetpub\wwwroot\COMPLAINTS\Modules\UDFeedBack"
Import-Module "C:\inetpub\wwwroot\COMPLAINTS\Modules\UniversalDashboard.UDMug\UniversalDashboard.UDMug.psd1" -Force
Import-Module "C:\inetpub\wwwroot\COMPLAINTS\Modules\UniversalDashboard.UDGhost\UniversalDashboard.UDGhost.psd1" -Force
Import-Module -Name UniversalDashboard.UDGauge
Import-Module -Name UniversalDashboard.UDTextLoop
###Stop any running dashboards so no conflict with port numbers
#Get-UDDashboard | Stop-UDDashboard
########
#$Endpoint1 = . (Join-Path $PSScriptRoot "Pages\EndPoint.ps1")
#$Endpoint2 = . (Join-Path $PSScriptRoot "Pages\EndPoint2.ps1")
#####Bring in some variable to use throughout the script
$Root = $PSScriptRoot
$Init = New-UDEndpointInitialization -Variable "Root" -Function @("Invoke-Sqlcmd2", "Get-ADGroupMembers") -Module @("UniversalDashboard.Gauge")
###Setup NavBar and Navbar links
$NavBarLinks = New-UDLink -Text "Log a support call" -Url "https://pensworth.zendesk.com" -Icon user -OpenInNewWindow
$Link = New-UDLink -Text 'Pensworth Website' -Url 'http://www.pensworth.co.uk' -Icon { globe } -OpenInNewWindow
$Footer = New-UDFooter -Copyright 'Designed by Adam Bacon' -Links $Link
$theme = . (Join-Path $Root "Pages\Theme.ps1")
$FormLogin = . (Join-Path $Root "Pages\FormLogin.ps1")
$LoginPage = New-UDLoginPage -AuthenticationMethod $FormLogin -LoginFormFontColor "#ffffff" -LoginFormBackgroundColor "#305768" -PageBackgroundColor '#FFFFFF' -Logo (New-UDImage -Path "$Root\imgs\Plogo.png") -Title "Pensworth Complaint System" -WelcomeText "Logon using your network credentials" -LoadingText "Please wait..." -LoginButtonFontColor "#FFFFFF" -LoginButtonBackgroundColor "#FF6666"
$HomePage = . (Join-Path $Root "Pages\HomePage1.ps1")
$HelpPage = . (Join-Path $Root "Pages\HelpPage.ps1")
$HistoryPage = . (Join-Path $Root "Pages\HistoryPage.ps1")
$NewPage = . (Join-Path $Root "Pages\NewPage.ps1")
$MyCallPage = . (Join-Path $Root "Pages\MyCallsPage.ps1")
$AllCallPage = . (Join-Path $Root "Pages\AllCallsPage2.ps1")
$AssignedPage = . (Join-Path $Root "Pages\AssignedToMePage.ps1")
$EditPage = . (Join-Path $Root "Pages\EditPage.ps1")
$StatsPage = . (Join-Path $Root "Pages\StatisticsPage.ps1")
$NewCustPage = . (Join-Path $Root "Pages\AddCustomerPage.ps1")
$Navigation = New-UDSideNav -Endpoint {
    New-UDSideNavItem -Text "HOME" -PageName "Home" -Icon home
    New-UDSideNavItem -Divider
    New-UDSideNavItem -Text "HELP" -PageName "Help" -Icon question
    if (Get-ADGroupMembers "UD_Complaints_Managers" | Where-Object { $_.SamAccountName -match "$User" }) {
        New-UDSideNavItem -Divider
        New-UDSideNavItem -Text "ALL COMPLAINTS" -PageName "AllComplaints" -Icon chart_line
    }
    if (Get-ADGroupMembers "UD_Complaints_Managers" | Where-Object { $_.SamAccountName -match "$User" }) {

        New-UDSideNavItem -Divider
        New-UDSideNavItem -Text "ASSIGNED TO ME" -PageName "AssignedComplaints" -Icon user_cog
    }
        New-UDSideNavItem -Divider
        New-UDSideNavItem -Text "HISTORY" -PageName "History" -Icon calendar_alt

    New-UDSideNavItem -Divider
    New-UDSideNavItem -Text "EDIT COMPLAINT" -PageName "Edit" -Icon pen_alt

    if (Get-ADGroupMembers "UD_Complaints_Users" | Where-Object { $_.SamAccountName -match "$User" }) {
        New-UDSideNavItem -Divider
        New-UDSideNavItem -Text "MY COMPLAINTS" -PageName "MyComplaints" -Icon chart_pie
    }
    New-UDSideNavItem -Divider
    New-UDSideNavItem -Text "NEW COMPLAINT" -PageName "New" -Icon plus_circle
    if (Get-ADGroupMembers "UD_Complaints_Managers" | Where-Object { $_.SamAccountName -match "$User" }) {

        New-UDSideNavItem -Divider
        New-UDSideNavItem -Text "STATISTICS" -PageName "Statistics" -Icon chart_pie
    }
    New-UDSideNavItem -Divider
    New-UDSideNavItem -Text "ADD CUSTOMER"  -PageName "AddCustomer" -Icon user_friends
    New-UDSideNavItem -Divider
} -Fixed
$Dashboard = New-UDDashboard -Title "PENSWORTH COMPLAINT SYSTEM" -Pages @(
    $HomePage,
    $HelpPage,
    $HistoryPage,
    $NewPage,
    $MyCallPage,
    $AllCallPage,
    $AssignedPage,
    $EditPage,
    $StatsPage,
    $NewCustPage
) -NavBarLogo (New-UDImage -Url "https://static.wixstatic.com/media/03c1b0_8f9e1df7f0d7476499603b7cca698034~mv2.png" -Height 51 -Width 187 ) -NavbarLinks $NavBarLinks -Theme $theme -Footer $Footer -NavBarColor "#2c505f" -NavBarFontColor "#000000" -EndpointInitialization $Init -LoginPage $LoginPage -Navigation $Navigation
#Start-UDDashboard -Dashboard $Dashboard -Port 8091 -AllowHttpForLogin -AutoReload
Start-UDDashboard -Wait -Dashboard (
$Dashboard
) -AllowHttpForLogin
###Inspired by https://gallery.technet.microsoft.com/scriptcenter/f16f2e89-0492-47a4-bb05-b016caf0e2da
Import-Module UniversalDashboard.Community
Get-UDDashboard | Stop-UDDashboard
##Get Ready for the dashboard
$NavBarLinks = @((New-UDLink -Text "Visit My Website" -Url "https://wwww.yoursite.com" -Icon medkit))
$Link = New-UDLink -Text 'Company Website' -Url 'http://www.yourcompany.com' -Icon globe
$Footer = New-UDFooter -Copyright 'Designed by Your Name' -Links $Link
$theme = New-UDTheme -Name "Basic" -Definition @{
    '.btn'       = @{
        'color'            = "#555555"
        'background-color' = "#f44336"
    }
    '.btn:hover' = @{
        'color'            = "#ffffff"
        'background-color' = "#C70303"
    }
    UDNavBar     = @{
        BackgroundColor = "black"
        FontColor       = "white"
    }
    UDFooter     = @{
        BackgroundColor = "black"
        FontColor       = "white"
    }
}
function Get-WebPage {
    <#
.SYNOPSIS
   Downloads web page from site.
.DESCRIPTION
   Downloads web page from site and displays source code or displays total bytes of webpage downloaded
.PARAMETER Url
    URL of the website to test access to.
.PARAMETER UseDefaultCredentials
    Use the currently authenticated user's credentials
.PARAMETER Proxy
    Used to connect via a proxy
.PARAMETER Credential
    Provide alternate credentials
.PARAMETER ShowSize
    Displays the size of the downloaded page in bytes
.NOTES
    Name: Get-WebPage
    Author: Boe Prox
    DateCreated: 08Feb2011
.EXAMPLE
    Get-WebPage -url "http://www.bing.com"

Description
------------
Returns the source code from bing.com -showsize
.EXAMPLE
    Get-WebPage -url "http://www.bing.com" -ShowSize

Description
------------
Returns the size of the webpage bing.com in bytes.
#>
    [cmdletbinding(
        DefaultParameterSetName = 'url',
        ConfirmImpact = 'low'
    )]
    Param(
        [Parameter(
            Mandatory = $True,
            Position = 0,
            ParameterSetName = '',
            ValueFromPipeline = $True)]
        [string][ValidatePattern("^(http|https)\://*")]$Url,
        [Parameter(
            Position = 1,
            Mandatory = $False,
            ParameterSetName = 'defaultcred')]
        [switch]$UseDefaultCredentials,
        [Parameter(
            Mandatory = $False,
            ParameterSetName = '')]
        [string]$Proxy,
        [Parameter(
            Mandatory = $False,
            ParameterSetName = 'altcred')]
        [switch]$Credential,
        [Parameter(
            Mandatory = $False,
            ParameterSetName = '')]
        [switch]$ShowSize

    )
    Begin {
        $psBoundParameters.GetEnumerator() | % {
            Write-Verbose "Parameter: $_"
        }

        #Create the initial WebClient object
        Write-Verbose "Creating web client object"
        $wc = New-Object Net.WebClient

        #Use Proxy address if specified
        If ($PSBoundParameters.ContainsKey('Proxy')) {
            #Create Proxy Address for Web Request
            Write-Verbose "Creating proxy address and adding into Web Request"
            $wc.Proxy = New-Object -TypeName Net.WebProxy($proxy, $True)
        }

        #Determine if using Default Credentials
        If ($PSBoundParameters.ContainsKey('UseDefaultCredentials')) {
            #Set to True, otherwise remains False
            Write-Verbose "Using Default Credentials"
            $wc.UseDefaultCredentials = $True
        }
        #Determine if using Alternate Credentials
        If ($PSBoundParameters.ContainsKey('Credentials')) {
            #Prompt for alternate credentals
            Write-Verbose "Prompt for alternate credentials"
            $wc.Credential = (Get-Credential).GetNetworkCredential()
        }

    }
    Process {
        Try {
            If ($ShowSize) {
                #Get the size of the webpage
                Write-Verbose "Downloading web page and determining size"
                "{0:N0}" -f ($wr.DownloadString($url) | Out-String).length -as [INT]
            }
            Else {
                #Get the contents of the webpage
                Write-Verbose "Downloading web page and displaying source code"
                $wc.DownloadString($url)
            }

        }
        Catch {
            Write-Warning "$($Error[0])"
        }
    }
}
$Initialization = New-UDEndpointInitialization -Function 'Get-WebPage'
$Homep = New-UDPage -Name "Home Page" -Icon home -Endpoint {
    New-UDCard -Id "left" -Title "Enter a valid https:// address" -Content {
        New-UDInput -Endpoint {
            param(
                [Parameter(Mandatory)][UniversalDashboard.ValidationErrorMessage("Invalid URL")][ValidatePattern('(http[s]?|[s]?ftp[s]?)(:\/\/)([^\s,]+)')][string]$Website
            )

            if (Test-path $env:TEMP\output.txt)
            { Remove-Item -Path "$env:TEMP\output.txt" }
            $Website | Out-File (Join-Path $env:TEMP "output.txt") -Force
            New-UDInputAction -Toast "Gathering $Website information" -Duration 3000
            $Session:URL = Get-WebPage $Website
        } -Validate
    }
    New-UDRow -Id "right" -AutoRefresh -RefreshInterval 3 -Endpoint {
        if (!(Test-Path -Path $env:TEMP\output.txt)) { "https://www.bing.com" > $env:TEMP\output.txt }
        Get-WebPage (Get-Content $env:TEMP\output.txt)
    }

}
$dashboard = New-UDDashboard -Title "Endpoint Initialization Demo" -Pages (
    $Homep
) -NavbarLinks $NavBarLinks -Footer $Footer -EndpointInitialization $Initialization -Theme $theme
Start-UDDashboard -Dashboard $dashboard -Port 8091 -Name DemoDashboard -AutoReload

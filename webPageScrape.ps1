
<#
.Synopsis
   Checks CVE for given software
.DESCRIPTION
   This is a function I have boshed together for a fellow scripter to hopefully help scrape a webpage for results
.EXAMPLE
   Get-CVE -Software Putty -Verbose
.EXAMPLE
   Get-Content C:\softwarelist.txt | Get-CVE
#>
function Get-CVE
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [string[]]$Software, 
         [Parameter(Position=1)]       
        [string]$RowTag = "srrowns" ,
         [Parameter(Position=2)]
        [string]$CVETag = "cvesummarylong"
    )

    Begin
    {
    $Start = Get-Date
    Write-Verbose "$($myinvocation.mycommand) is starting now $((Get-Date).ToString('yyyy-MM-dd HH:MM:ss'))"
    }
    Process
    {
$URL = "https://www.cvedetails.com/vulnerability-search.php?f=1&vendor=&product=$($Software)%25&cveid=&msid=&bidno=&cweid=&cvssscoremin=&cvssscoremax=&psy=&psm=&pey=&pem=&usy=&usm=&uey=&uem="
$page = Invoke-WebRequest -Uri $URL
Write-Verbose "Calculating the number of CVE threats found for $($Software)"
[int]$CVEnumber = ($page.ParsedHtml.getElementsByTagName("td") | ? {$_.Classname -eq $CVETag}).count
if ($CVEnumber -lt 1){
Write-Verbose "Sorry no CVE threats found for the software $($Software)";break
} else {
Write-Verbose "There has been $($CVEnumber) threat(s) found for $($Software)"
Write-Verbose "Processing each CVE threat found"
$TR = $page.ParsedHtml.getElementsByTagName('tr') | ? {$_.Classname -eq $RowTag}
$TD = $page.ParsedHtml.getElementsByTagName('td') | ? {$_.Classname -eq $CVETag}
$HashOutput=[ordered]@{}
for($i=0; $i -lt $TR.count; $i++){
$HashOutput[$TR[$i].innertext] = $TD[$i].innertext }
Write-Verbose "CSV file now being created and stored here $($env:TEMP)"
[pscustomobject]$HashOutput | Export-Csv "$env:TEMP\$($Software).csv" -NoTypeInformation -Force

    }
}
    End
    {
    $End = Get-Date
    Write-Verbose "$($myinvocation.mycommand) is starting now $((Get-Date).ToString('yyyy-MM-dd HH:MM:ss'))"
    Write-Verbose "This script took $((New-TimeSpan -Start $Start -End $End).TotalSeconds) seconds to complete"

    }
}

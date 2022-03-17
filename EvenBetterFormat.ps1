$URL = "https://www.cvedetails.com/vulnerability-search.php?f=1&vendor=&product=putty%25&cveid=&msid=&bidno=&cweid=&cvssscoremin=&cvssscoremax=&psy=&psm=&pey=&pem=&usy=&usm=&uey=&uem="
$page = Invoke-WebRequest -Uri $URL
# Getting table by ID.
$CVEtable = $page.ParsedHtml.getElementByID("vulnslisttable")
# Extracting table rows as a collection.
$TableBody = $CVEtable.childNodes | Where-Object { $_.tagName -eq "TBODY" }
$TableRows = $TableBody.childNodes | Where-Object { $_.tagName -eq "TR" }
# Creating a collection of table headers.
$TableHeaders = $TableRows[0].childNodes | Where-Object { $_.tagName -eq "TH" } | select -expandproperty InnerText
$ColumnTableHeaders = @($TableHeaders)
# Converting rows to a collection of PS objects exportable to CSV.
$CSVobject = @()
foreach ($TableRow in $TableRows) {
    $TableData = $TableRow.childNodes | Where-Object { $_.tagName -eq "TD" }
    # Skipping the first row (headers).
    if ([String]::IsNullOrEmpty($TableData)) { continue }
    $RowObject = New-Object PSObject
    for ($i = 0; $i -lt $ColumnTableHeaders.Count; $i++) {
        $RowObject | Add-Member -MemberType NoteProperty -Name $ColumnTableHeaders[$i] `
            -Value $TableData[$i].innertext
    }
    $CSVobject += $RowObject
}
$CSVobject | ? `# -Match "\d" | Export-Csv -Path $env:TEMP\export.csv -NoTypeInformation
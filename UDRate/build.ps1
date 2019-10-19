$BuildFolder = $PSScriptRoot

$powerShellGet = Import-Module PowerShellGet  -PassThru -ErrorAction Ignore
if ($powerShellGet.Version -lt ([Version]'2.1.4')) {
    Install-Module PowerShellGet -Scope CurrentUser -Force -AllowClobber
    Import-Module PowerShellGet -Force
}

Set-Location $BuildFolder

$OutputPath = "$BuildFolder\output\UDRate"

Remove-Item -Path "$BuildFolder\output" -Force -ErrorAction SilentlyContinue -Recurse
Remove-Item -Path "$BuildFolder\public" -Force -ErrorAction SilentlyContinue -Recurse

New-Item -Path $OutputPath -ItemType Directory

# & cyclonedx-bom -o antd.bom.xml
npm install
npm run build

Copy-Item $BuildFolder\public $OutputPath\jsfiles -Recurse -Force
Copy-Item $BuildFolder\PowerShell\Scripts $OutputPath\Scripts -Recurse -Force
Copy-Item $BuildFolder\"UDRate.psm1" $OutputPath

Remove-Item -Path "$BuildFolder\public" -Force -ErrorAction SilentlyContinue -Recurse

$Version = "1.0.0"

$manifestParameters = @{
    Path              = "$OutputPath\UDRate.psd1"
    Author            = ""
    CompanyName       = ""
    Copyright         = "2019 YOU"
    RootModule        = "UDRate.psm1"
    Description       = ""
    ModuleVersion     = $Version
    Tags              = @("universal-dashboard","control","rate")
    ReleaseNotes      = "First release"
    FunctionsToExport = @(
        "New-UDRate"
    )
}

New-ModuleManifest @manifestParameters

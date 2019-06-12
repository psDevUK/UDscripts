###Taken from https://forums.universaldashboard.io/t/simple-udelement-example-meme-factory/540
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
Function Get-RandomMeme {
    $Meme = Invoke-WebRequest -Uri 'https://api.imgflip.com/get_memes'
    $Memes = ($Meme.Content | ConvertFrom-Json).data.memes
    $RandomMeme = ($Memes | Get-Random | Select-Object name, url, width, height, box_count)
    return $RandomMeme
}
$Initialization = New-UDEndpointInitialization -Function 'Get-RandomMeme'
$Homep = New-UDPage -Name "Home Page" -Icon home -Content {
    New-UDButton -Text "Get New Meme" -OnClick {

        $NewRandomMeme = Get-RandomMeme

        # Toast
        Show-UDToast -Message "Now Loading: $($NewRandomMeme.name)"

        # Set Image
        Set-UDElement -Id "imgMeme" -Attributes @{
            src = $NewRandomMeme.url
        }

        # Set Label
        Set-UDElement -Id "lblMeme" -Content { $NewRandomMeme.name }

    }

    New-UDHtml -Markup "<br />"
    New-UDElement -ID "lblMeme" -Tag "div" -Content { "" }
    New-UDElement -ID "imgMeme" -Tag "img" -Attributes @{src = "" }

}
$dashboard = New-UDDashboard -Title "Sync Demo" -Pages (
    $Homep
) -NavbarLinks $NavBarLinks -Footer $Footer -EndpointInitialization $Initialization -Theme $theme
Start-UDDashboard -Dashboard $dashboard -Port 8091 -Name DemoDashboard -AutoReload

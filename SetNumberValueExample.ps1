Import-Module UniversalDashboard
Import-Module UniversalDashboard.UDNumberMask

#$endpointinit = New-UDEndpointInitialization -Module @("UniversalDashboard.UDCustomGauge")
Get-UDDashboard | Stop-UDDashboard
$theme = New-UDTheme -Name "Basic" -Definition @{
    '::placeholder' = @{
        'color'   = "black"
        'opacity' = "1"
    }
} -Parent "Default"
$dashboard = New-UDDashboard -Title "New Component" -Theme $theme -Content {
    New-UDRow -Columns {
        New-UDColumn -size 2 -Endpoint {
            New-UDNumberMask -Id "num1" -Format "##/##" -PlaceHolder "MM/YY" -Mask "M", "M", "Y", "Y"  -OnChange {
                Show-UDToast -Message "You have entered:-$eventData" -Position topLeft -Duration 2000
            }
            New-UDNumberMask -Id "num2" -Format "###.###.#.##" -PlaceHolder "Ip Address"
            Set-UDElement -Id "num2" -Attributes @{
                value = "222.222.2.22"
            }
            New-UDNumberMask -Id "num3" -Format "####-####-####-####" -PlaceHolder "Formatted Card"
            New-UDNumberMask -Id "num4" -Format "+44 (#####)-######" -PlaceHolder "Phone Number"

            New-UDButton -Text "Toast" -OnClick {
                #Show-UDToast -Message "You typed $(Get-UDElement -Id 'num2')" -Duration 4000
                $val = (Get-UDElement -id "num2").Attributes.value
                Show-UDToast -Message "IP Address:- $val" -Position topLeft -Duration 4000
            }
            New-UDButton -Text "RemoveMe" -OnClick {
                Remove-UDElement -id "num2"
            }
            New-UDButton -text "ShowME" -OnClick {
                Set-UDElement -id "num2" -Attributes @{
                    hidden = $false
                }
            }
            New-UDButton -Text "ClearMe" -OnClick {
                #Clear-UDElement -Id "num2"
            }

        } -AutoRefresh
    }

}
Start-UDDashboard -Dashboard $dashboard -Port 10005
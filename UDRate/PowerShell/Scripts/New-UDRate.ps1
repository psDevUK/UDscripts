
function New-UDRate {
    param(
        [Parameter()]
        [string]$Id = (New-Guid).ToString(),
        [Parameter()]
        [string]$ClassName,
        [Parameter()]
        [switch]$Editable,
        [Parameter()]
        [object]$OnChange,
        [Parameter()]
        [string]$ActiveColor = '#FFED76',
        [Parameter()]
        [string]$InactiveColor = '#121621',
        [Parameter()]
        [int]$Size,
        [Parameter()]
        [hashtable]$Style

    )

    End {

        # Example for On$OnChange event 
        # Parameter value can only be ScriptBlock {} or UDEndpont.
        if ($null -ne $OnChange) {
            if ($OnChange -is [scriptblock]) {
                $OnChange = New-UDEndpoint -Endpoint $OnChange -Id ($Id + "OnChange")
            }
            elseif ($OnChange -isnot [UniversalDashboard.Models.Endpoint]) {
                throw "On$OnChange must be a script block or UDEndpoint"
            }
        }


        @{
            # Mandatory - DO NOT DELETE !!
            assetId     = $AssetId 
            isPlugin    = $true 
            id          = $Id
            type        = "ud-rate"
            className   = $ClassName
            style       = $Style
            hasCallBack = $null -ne $OnChange
            editable = $Editable.IsPresent
            inactiveColor = $InactiveColor
            activeColor = $ActiveColor
            size = $Size
        }

    }
}

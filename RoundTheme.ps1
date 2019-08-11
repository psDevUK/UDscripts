New-UDTheme -Name "Basic" -Definition @{
    '.btn'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                = @{
        'color'            = "#ffffff"
        'background-color' = "#426675"
        'border-radius'    = "12px"
    }
    '.btn:hover'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          = @{
        'color'            = "#ffffff"
        'background-color' = "#9a031e"
    }
    '.select-dropdown li span'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            = @{
        'color' = "#ffffff"
    }
    # '.content'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            = @{
    #     'background-color' = "#1e353f"
    # }
    '.sidenav'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            = @{
        'background-color' = "#284856"
        'margin-top'       = "75px"
        'height'           = "77%"
        'border-radius'    = "8px"
        'box-shadow'       = "none"
        'z-index'          = "0"
    }

    '.sidenav a:hover'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    = @{
        'background-color' = "#1e353f"
        'color'            = "#e16036"
    }
    '.sidenav li > a'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     = @{
        'color'     = "#f1f1f1"
        'font-size' = "18px"
    }
    'li'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  = @{
        'color' = "#ffffff"
    }
    '.collapsible-header'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 = @{
        'background-color' = "#1e353f"
        'border-bottom'    = "1px solid #dce6ea"
    }
    '.active'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             = @{
        'color' = "#c6c4c4"
    }
    '.select-wrapper input.select-dropdown'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               = @{
        'color'                  = "#ffffff"
        'border-bottom'          = "1px solid #e0eec6"
        'border-block-end-color' = "white"
        'font-size'              = "18px"
    }
    '.dropdown-content'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   = @{
        'background-color' = "#305768"
    }

    'input:not([type]), input[type="date"]:not(.browser-default), input[type="datetime-local"]:not(.browser-default), input[type="datetime"]:not(.browser-default), input[type="email"]:not(.browser-default), input[type="number"]:not(.browser-default), input[type="password"]:not(.browser-default), input[type="search"]:not(.browser-default), input[type="tel"]:not(.browser-default), input[type="text"]:not(.browser-default), input[type="time"]:not(.browser-default), input[type="url"]:not(.browser-default), textarea.materialize-textarea' = @{
        'border-bottom' = "1px solid #f1f1f1"
        'font-size'     = "18px"
        'color'         = "#f1f1f1"
    }

    'nav'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 = @{
        'left'  = "0"
        'right' = "0"

    }
    '.file-field'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         = @{
        'position' = "sticky"
        'display'  = "inline-block"
    }
    '.file-field .btn, .file-field .btn-large, .file-field .btn-small'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    = @{
        'float'       = "right"
        'height'      = "3rem"
        'line-height' = "3rem"
    }
    '.card .card-content'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 = @{
        'padding'       = "0px"
        'border-radius' = "25px"
        'display'       = "grid"
    }
    UDInput                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               = @{
        BackgroundColor = "#1e353f"
        FontColor       = "#ffffff"
        'box-shadow'    = 'none'
    }
    UDGrid                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                = @{
        BackgroundColor = "#1e353f"
        FontColor       = "#ffffff"
        'box-shadow'    = "none"
    }
    UDCounter                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             = @{
        BackgroundColor = "#1e353f"
        FontColor       = "#ffffff"
        'box-shadow'    = 'none'
        'margin-left'   = '6rem'
        'z-index'       = "0"
    }
    UDCard                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                = @{
        BackgroundColor = "#1e353f"
        FontColor       = "#ffffff"
        'border-radius' = "12px"
        'padding'       = "12px"
        'padding-bottom' = "20px !important"
    }
    UDDashboard                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           = @{
        BackgroundColor = "#557583"
        FontColor       = "#FFFFF"
    }
    ".ud-navbar"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          = @{
        'width'    = "100%"
        'position' = "fixed"
        'z-index'  = "9999"
    }
    'main'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                = @{
        'flex'       = "1 0 auto"
        'margin-top' = "4.7rem"
    }
    'img'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 = @{
        'border-radius' = "8px"
        'float' ="left"
    }
    '.card .card-image'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   = @{
        'position'      = "relative"
        'border-radius' = "8px"
    }
    '.modal'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              = @{
        'z-index' = "9999 !important"
        'max-width' = "90% !important"
        'max-height' = "90% !important"
        'width' = "90% !important"
    }
    'h4' = @{
        'line-height' = "50%"
    }
     '.left-align' = @{
         'text-align' = "start"
     }
     '.svg-inline--fa' = @{
         color = "#fff"
     }
     '.pagination li a' = @{
         color = "#fff !important"
     }
     '.tabs'                                                                                                                    = @{
        'color' = "#2c505f"
        'margin-top' = "-7px"
        'background-color' = "#2c505f"
    }

    '.tabs .tab a:hover'                                                                                                            = @{
        'background-color' = "#557583"
        'color'            = "#ffffff"
    }

    '.tabs .tab a.active'                                                                                                           = @{
        'background-color' = "#2c505f"
        'color'            = "#ffffff"
    }
    '.tabs .tab a:focus.active'                                                                                                     = @{
   'background-color' = "#1e353f"
        'color'            = "#ffffff"
    }
    '.tabs .indicator'                                                                                                              = @{
        'background-color' = "#fff"
    }
    '.tabs .tab a'                                                                                                                  = @{
        'color' = "#fff"
    }
    'label' = @{
        'font-size' = "1rem"
        'display' = "block"
    }

}
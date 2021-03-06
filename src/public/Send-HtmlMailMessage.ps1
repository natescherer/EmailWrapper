function Send-HtmlMailMessage {
    <#
    .SYNOPSIS
        Sends a nicely formatted HTML email.

    .DESCRIPTION
        Sends a nicely formatted HTML email. This cmdlet is designed to work just like Send-MailMessage, with -Heading, 
        -Body, -BodyFormatted, and -Footer replacing the default -Body of Send-MailMessage.

    .INPUTS
        No inputs

    .OUTPUTS
        No outputs

    .EXAMPLE
        Send-HtmlMailMessage -From "server01@contoso.com" -To "admin@contoso.com"

    .LINK
        https://github.com/natescherer/PoshEmail
    #>
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
        [parameter(ParameterSetName = "Default", Mandatory = $true)]
        [parameter(ParameterSetName = "Button", Mandatory = $true)]
        # Specifies the address from which the mail is sent. Can either be an email address, or, optionally, a name 
        # and email address combo in the format 'Someone <someone@example.com>'
        [string]$From,

        [parameter(ParameterSetName = "Default", Mandatory = $true)]
        [parameter(ParameterSetName = "Button", Mandatory = $true)]
        # Specifies the subject of the email message. This parameter is required.
        [string]$Subject,

        [parameter(ParameterSetName = "Default", Mandatory = $true)]
        [parameter(ParameterSetName = "Button", Mandatory = $true)]
        # Specifies the addresses to which the mail is sent. Can either be an email address, or, optionally, a name 
        # and email address combo in the format 'Someone <someone@example.com>'
        [string[]]$To,

        [parameter(ParameterSetName = "Default", Mandatory = $true)]
        [parameter(ParameterSetName = "Button", Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        # Specifies a string to use as the body of the message.
        # If you have a multi-paragraph body, wrapped each paragraph as follows:
        # - <p>Paragraph 1</p><p>Paragraph 2</p>
        # If you want to include preformatted data, it is recommended to use the -BodyPreformatted attribute 
        # for that.
        [string]$Body,

        [parameter(ParameterSetName = "Default", Mandatory = $false)]
        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        # Specifies how the body should be aligned. The acceptable values for this parameter are:
        # - Left
        # - Center
        # - Right
        # Left is the default.
        [string]$BodyAlignment = "Left",

        [parameter(ParameterSetName = "Default", Mandatory = $false)]
        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        # Specifies a string of preformmated text (code, cmdlet output, etc) to include below the body of the message.
        # This will be displayed either in a horizontally-scrolling box or, if Outlook (which can't support 
        # scrolling) wrapped with line numbers.
        [string]$BodyPreformatted = "",

        [parameter(ParameterSetName = "Default", Mandatory = $false)]
        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        # Specifies the path to files to attach to the message.
        [string[]]$Attachments,

        [parameter(ParameterSetName = "Default", Mandatory = $false)]
        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        # Specifies the email addresses that receive a copy of the mail but are not listed as recipients of the 
        # message. Can either be an email address, or, optionally, a name and email address combo in the format 
        # 'Someone <someone@example.com>'
        [string[]]$Bcc,

        [parameter(ParameterSetName = "Default", Mandatory = $false)]
        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        # Specifies the email addresses to which a carbon copy (CC) of the email message is sent. Can either be 
        # an email address, or, optionally, a name and email address combo in the format 
        # 'Someone <someone@example.com>'.
        [string[]]$Cc,

        [parameter(ParameterSetName = "Default", Mandatory = $false)]
        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        # Specifies a PSCredential object, containing credentials used to send the message.
        [pscredential]$Credential,

        [parameter(ParameterSetName = "Default", Mandatory = $false)]
        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateSet("None", "OnSuccess", "OnFailure", "Delay", "Never")]
        # Specifies the delivery notification options for the email message.
        # The acceptable values for this parameter are:
        # - None. No notification.
        # - OnSuccess. Notify if the delivery is successful.
        # - OnFailure. Notify if the delivery is unsuccessful.
        # - Delay. Notify if the delivery is delayed.
        # - Never. Never notify.
        # None is the default.
        [string]$DeliveryNotificationOption,

        [parameter(ParameterSetName = "Default", Mandatory = $false)]
        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateSet("ASCII", "UTF8", "UTF7", "UTF32", "Unicode", "BigEndianUnicode", "Default", "OEM")]
        # Specifies the encoding used for the body and subject. The acceptable values for this parameter are:
        # - ASCII
        # - UTF8
        # - UTF7
        # - UTF32
        # - Unicode
        # - BigEndianUnicode
        # - Default
        # - OEM
        # UTF8 is the default.
        [string]$Encoding = "UTF8",

        [parameter(ParameterSetName = "Default", Mandatory = $false)]
        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateNotNull()]
        # Specifies the port on which to connect to the SMTP server.
        # Defaults to 587.
        [int]$Port,

        [parameter(ParameterSetName = "Default", Mandatory = $true)]
        [parameter(ParameterSetName = "Button", Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        # Specifies the FQDN or IP address of the SMTP server that will send the message.
        [string]$SmtpServer,

        [parameter(ParameterSetName = "Default", Mandatory = $false)]
        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateSet("High", "Normal", "Low")]
        # Specifies the priority of the email message. The acceptable values for this parameter are:
        # - Normal
        # - High
        # - Low
        # Normal is the default.
        [string]$Priority,

        [parameter(ParameterSetName = "Default", Mandatory = $false)]
        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateNotNull()]
        # Specifies a string (with optional HTML formatting) to include in the heading of the message.
        [string]$Heading = "",

        [parameter(ParameterSetName = "Default", Mandatory = $false)]
        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        # Specifies how the heading should be aligned. The acceptable values for this parameter are:
        # - Left
        # - Center
        # - Right
        # Center is the default.
        [string]$HeadingAlignment = "Center",

        [parameter(ParameterSetName = "Default", Mandatory = $false)]
        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateNotNull()]
        # Specifies a string (with optional HTML formatting) to include in the footer of the message.
        [string]$Footer = "",

        [parameter(ParameterSetName = "Button", Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        # Specifies a string to use as label for an optional button.
        [string]$ButtonText,

        [parameter(ParameterSetName = "Button", Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        # Specifies a link to use as a target for an optional button.
        [string]$ButtonLink,

        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        # Specifies how the button should be aligned. The acceptable values for this parameter are:
        # - Left
        # - Center
        # - Right
        # Center is the default.
        [string]$ButtonAlignment = "Center",

        [parameter(ParameterSetName = "Default", Mandatory = $false)]
        [parameter(ParameterSetName = "Button", Mandatory = $false)]
        [ValidateScript({
            (![string]::IsNullOrEmpty($_.BodyTextColor)) -and
            (![string]::IsNullOrEmpty($_.BackgroundColor)) -and
            (![string]::IsNullOrEmpty($_.ContainerColor)) -and
            (![string]::IsNullOrEmpty($_.HeadingTextColor)) -and
            (![string]::IsNullOrEmpty($_.FooterTextColor)) -and
            (![string]::IsNullOrEmpty($_.LinkColor)) -and
            (![string]::IsNullOrEmpty($_.ButtonColor)) -and
            (![string]::IsNullOrEmpty($_.ButtonTextColor))
        })]
        # Specifies a hashtable containing a color scheme if you wish to use non-default colors.
        [hashtable]$ColorScheme = @{
            BodyTextColor = "#000000"
            BackgroundColor = "#f6f6f6"
            ContainerColor = "#ffffff"
            HeadingTextColor = "#000000"
            FooterTextColor = "#999999"
            LinkColor = "#999999"
            ButtonColor = "#3498db"
            ButtonTextColor = "#ffffff"
        }
    )

    $NL = [System.Environment]::NewLine

    if ($BodyPreformatted) {
        $BodyWidth = "1800"
    }
    else {
        $BodyWidth = "580"
    }

    $HtmlTop = ("<!doctype html>$NL" +
        "<html>$NL" +
        "  <head>$NL" +
        "    <meta name=`"viewport`" content=`"width=device-width`">$NL" +
        "    <meta http-equiv=`"Content-Type`" content=`"text/html; charset=UTF-8`">$NL" +
        "    <title></title>$NL" +
        "    <style>$NL" +
        "    /* -------------------------------------$NL" +
        "        INLINED WITH htmlemail.io/inline$NL" +
        "    ------------------------------------- */$NL" +
        "    /* -------------------------------------$NL" +
        "        RESPONSIVE AND MOBILE FRIENDLY STYLES$NL" +
        "    ------------------------------------- */$NL" +
        "    @media only screen and (max-width: 620px) {$NL" +
        "      table[class=body] h1 {$NL" +
        "        font-size: 28px !important;$NL" +
        "        margin-bottom: 10px !important;$NL" +
        "      }$NL" +
        "      table[class=body] p,$NL" +
        "      table[class=body] ul,$NL" +
        "      table[class=body] ol,$NL" +
        "      table[class=body] td,$NL" +
        "      table[class=body] span,$NL" +
        "      table[class=body] a {$NL" +
        "        font-size: 16px !important;$NL" +
        "      }$NL" +
        "      table[class=body] .preformatted {$NL" +
        "        font-size: 11px !important;$NL" +
        "      }$NL" +
        "      table[class=body] .wrapper,$NL" +
        "            table[class=body] .article {$NL" +
        "        padding: 10px !important;$NL" +
        "      }$NL" +
        "      table[class=body] .content {$NL" +
        "        padding: 0 !important;$NL" +
        "      }$NL" +
        "      table[class=body] .container {$NL" +
        "        padding: 0 !important;$NL" +
        "        width: 100% !important;$NL" +
        "      }$NL" +
        "      table[class=body] .main {$NL" +
        "        border-left-width: 0 !important;$NL" +
        "        border-radius: 0 !important;$NL" +
        "        border-right-width: 0 !important;$NL" +
        "      }$NL" +
        "      table[class=body] .btn table {$NL" +
        "        width: 100% !important;$NL" +
        "      }$NL" +
        "      table[class=body] .btn a {$NL" +
        "        width: 100% !important;$NL" +
        "      }$NL" +
        "      table[class=body] .img-responsive {$NL" +
        "        height: auto !important;$NL" +
        "        max-width: 100% !important;$NL" +
        "        width: auto !important;$NL" +
        "      }$NL" +
        "    }$NL" +
        "$NL" +
        "    /* -------------------------------------$NL" +
        "        PRESERVE THESE STYLES IN THE HEAD$NL" +
        "    ------------------------------------- */$NL" +
        "    @media all {$NL" +
        "      .ExternalClass {$NL" +
        "        width: 100%;$NL" +
        "      }$NL" +
        "      .ExternalClass,$NL" +
        "      .ExternalClass p,$NL" +
        "      .ExternalClass span,$NL" +
        "      .ExternalClass font,$NL" +
        "      .ExternalClass td,$NL" +
        "      .ExternalClass div {$NL" +
        "        line-height: 100%;$NL" +
        "      }$NL" +
        "      .btn-primary table td:hover {$NL" +
        "        background-color: $($ColorScheme.ButtonColor) !important;$NL" +
        "      }$NL" +
        "      .btn-primary a:hover {$NL" +
        "        background-color: $($ColorScheme.ButtonColor) !important;$NL" +
        "        border-color: $($ColorScheme.ButtonColor) !important;$NL" +
        "      }$NL" +
        "    }$NL" +
        "   </style>$NL" +
        "  </head>$NL" +
        "  <body class=`"`" style=`"background-color: $($ColorScheme.BackgroundColor); font-family: sans-serif; -webkit-font-smoothing: antialiased; font-size: 14px; line-height: 1.4; margin: 0; padding: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;`">$NL" +
        "    <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"body`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background-color: $($ColorScheme.BackgroundColor);`">$NL" +
        "      <tr>$NL" +
        "        <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">&nbsp;</td>$NL" +
        "        <td class=`"container`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; display: block; margin: 0 auto; max-width: $($BodyWidth)px; padding: 10px;`">$NL" +
        "          <div class=`"content`" style=`"box-sizing: border-box; display: block; margin: 0 auto; max-width: 100%; padding: 10px;`">$NL" +
        "$NL" +
        "            <!-- START CENTERED CONTAINER -->$NL" +
        "            <span class=`"preheader`" style=`"color: transparent; display: none; height: 0; max-height: 0; max-width: 0; opacity: 0; overflow: hidden; mso-hide: all; visibility: hidden; width: 0;`"></span>$NL" +
        "            <table class=`"main`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background: $($ColorScheme.ContainerColor); border-radius: 3px;`">$NL" +
        "$NL" +
        "              <!-- START MAIN CONTENT AREA -->$NL" +
        "              <tr>$NL" +
        "                <td class=`"wrapper`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; box-sizing: border-box; padding: 20px;`">$NL" +
        "                  <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;`">$NL" +
        "                    <tr>$NL" +
        "                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">$NL")

    $HtmlButton = ("                        <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"btn btn-primary`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; box-sizing: border-box;`">$NL" +
        "                          <tbody>$NL" +
        "                            <tr>$NL" +
        "                              <td align=`"$($ButtonAlignment.ToLower())`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; padding-bottom: 15px;`">$NL" +
        "                                <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: auto;`">$NL" +
        "                                  <tbody>$NL" +
        "                                    <tr>$NL" +
        "                                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; background-color: $($ColorScheme.ButtonColor); border-radius: 5px; text-align: center;`"> <a href=`"$ButtonLink`" target=`"_blank`" style=`"display: inline-block; color: $($ColorScheme.ButtonTextColor); background-color: $($ColorScheme.ButtonColor); border: solid 1px $($ColorScheme.ButtonColor); border-radius: 5px; box-sizing: border-box; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 25px; text-transform: capitalize; border-color: $($ColorScheme.ButtonColor);`">$ButtonText</a> </td>$NL" +
        "                                    </tr>$NL" +
        "                                  </tbody>$NL" +
        "                                </table>$NL" +
        "                              </td>$NL" +
        "                            </tr>$NL" +
        "                          </tbody>$NL" +
        "                        </table>$NL")

    $HtmlDataToFooter = ("                      </td>$NL" +
        "                    </tr>$NL" +
        "                  </table>$NL" +
        "                </td>$NL" +
        "              </tr>$NL" +
        "$NL" +
        "            <!-- END MAIN CONTENT AREA -->$NL" +
        "            </table>$NL" +
        "$NL" +
        "            <!-- START FOOTER -->$NL" +
        "            <div class=`"footer`" style=`"clear: both; margin-top: 10px; text-align: center; width: 100%;`">$NL" +
        "              <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;`">$NL" +
        "                <tr>$NL" +
        "                  <td class=`"content-block`" style=`"font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; font-size: 12px; color: $($ColorScheme.FooterTextColor); text-align: center;`">$NL")

    $HtmlBottom = ("                  </td>$NL" +
        "                </tr>$NL" +
        "              </table>$NL" +
        "            </div>$NL" +
        "            <!-- END FOOTER -->$NL" +
        "$NL" +
        "          <!-- END CENTERED CONTAINER -->$NL" +
        "          </div>$NL" +
        "        </td>$NL" +
        "        <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">&nbsp;</td>$NL" +
        "      </tr>$NL" +
        "    </table>$NL" +
        "  </body>$NL" +
        "</html>$NL")

    if (!$ButtonText) {
        $HtmlButton = ""
    }

    $Heading = "                        <h2 style=`"text-align: $($HeadingAlignment.ToLower()); color: $($ColorScheme.HeadingTextColor);`">$Heading</h2>$NL"

    if ($Body -notlike "*<p>*") {
        $Body = "<p>$Body</p>"
    }

    if ($Body -like "*<table>*") {
        $Body = $Body -replace '<table>', '<table cellpadding="5" style="border-collapse: collapse; border: 1px solid black;">'
        $Body = $Body -replace '<th>', '<th style="background-color: gray; border: 1px solid black;">'
        $Body = $Body -replace '<td>', '<td style="border: 1px solid black;">'
    }

    if ($Footer) {
        $Footer = "                    $Footer$NL"
    }

    $Body = $Body -replace "<p>", "                        <p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; color: $($ColorScheme.BodyTextColor); margin: 0; margin-bottom: 15px; text-align: $($BodyAlignment.ToLower());`">"
    $Body = $Body -replace "</p>", "</p>$NL"
    if ($BodyPreformatted -ne "") {
        $BodyReformatted = ""
        foreach ($Line in $BodyPreformatted -split $NL) {
            $Line = $Line -replace " ", "&ensp;"
            $BodyReformatted += "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">$Line</span></li>$NL"
        }

        $BodyPreformatted = ("                      </td>$NL" +
            "                    </tr>$NL" +
            "                    <tr>$NL" +
            "                      <td class=`"preformatted`" width=`"100%`" style=`"font-size: 14px; vertical-align: top; max-width: 100%; overflow: auto; padding-top: 15px; padding-right: 15px;background-color: #F5F5F5; border: 1px solid black;`">$NL" + 
            "                        <ol class=`"preformatted`">$NL" +
            "$BodyReformatted" +
            "                        </ol>$NL")
        $BodyPreformatted = $BodyPreformatted + ("                      </td>$NL" +
            "                    </tr>$NL" +
            "                    <tr>$NL" +
            "                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">$NL" +
            "                        <p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px; text-align: $($BodyAlignment.ToLower());`">&nbsp;</p>$NL")
    }
    $Body = $Body -replace "<a ", "<a style=`"text-decoration: underline; color: $($ColorScheme.LinkColor); font-size: 16px; text-align: center;`" "
    $Footer = $Footer -replace "<a ", "<a style=`"text-decoration: underline; color: #999999; font-size: 12px; text-align: center;`" "

    $CompleteBody = $HtmlTop + $Heading + $Body + $BodyPreformatted + $HtmlButton +
    $HtmlDataToFooter + $Footer + $HtmlBottom

    $MessageParams = @{
        SmtpServer = $SmtpServer
        Port = $Port
        From = $From
        To = $To
        Subject = $Subject
        HTML = $CompleteBody
        Encoding = $Encoding
    }

    if ($Attachments) {
        $MessageParams += @{Attachments = $Attachments }
    }

    if ($Bcc) {
        $MessageParams += @{Bcc = $Bcc }
    }

    if ($Cc) {
        $MessageParams += @{Cc = $Cc }
    }

    if ($Credential) {
        $MessageParams += @{Credential = $Credential }
    }

    if ($DeliveryNotificationOption) {
        $MessageParams += @{DeliveryNotificationOption = $DeliveryNotificationOption }
    }

    if ($Priority) {
        $MessageParams += @{Priority = $Priority }
    }

    Send-EmailMessage @MessageParams
}
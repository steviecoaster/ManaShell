function Show-Card {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [PSObject]
        $CardData
    )

    end {
        $cardface = Get-SpectreImage -ImagePath $CardData.image_uris.png -Format Auto -MaxWidth 90
        $info = @'
        Card     : {0}
        Released : {1}
        Type     : {2}
        Oracle   : {3}
'@ -f $CardData.name, $CardData.released_at, $CardData.type_line, $CardData.oracle_text
        #$cardRow = $cardface | Format-SpectreColumns -Padding 0 | Format-SpectreRows
        $infoRow = $cardface, $info | Format-SpectreColumns -Padding 0
        @($cardface,$info) | Format-SpectreColumns -Padding 0 | Format-SpectrePanel -Title ('MtG Card: {0}' -f $CardData.name) -Color aquamarine3 -Border Rounded -Height 80 | Out-SpectreHost
    }
}
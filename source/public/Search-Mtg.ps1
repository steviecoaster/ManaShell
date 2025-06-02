function Search-Mtg {
<#
.SYNOPSIS
Searches for Magic: The Gathering cards using the Scryfall API.

.DESCRIPTION
The `Search-Mtg` function allows you to search for Magic: The Gathering cards based on card color and/or mana value. 
It constructs a query string and sends a request to the Scryfall API to retrieve card data.

.PARAMETER CardColor
Specifies the color of the card to search for. 

.PARAMETER ManaValue
Specifies the mana value (converted mana cost) of the card to search for.

.OUTPUTS
Returns the card data retrieved from the Scryfall API as a PowerShell object.

.EXAMPLE
Search-Mtg -CardColor "White"
Searches for all white cards.

.EXAMPLE
Search-Mtg -ManaValue D1
Searches for all cards with a mana value of 3.

.EXAMPLE
Search-Mtg -CardColor "White" -ManaValue D2
Searches for all blue cards with a mana value of 1.

.NOTES
- This function uses the Scryfall API to perform the search.
#>
    [CmdletBinding(HelpUri = 'https://steviecoaster.githubpages.io/ManaShell/Search-Mtg/')]
    Param(
        [Parameter()]
        [String]
        $CardColor,

        [Parameter()]
        [String]
        $ManaValue
    )

    end {
        $queryString = if ($CardColor) {
            New-QueryString -QueryParameter @{q = 'c:{0}' -f $CardColor }
        }
        elseif ($ManaValue) {
            New-QueryString -QueryParameter @{q = 'mv:{0}' -f $ManaValue }
        }
        elseif ($CardColor -and $ManaValue) {
            New-QueryString -QueryParameter @{q = 'c:{0}+mv:{1}' -f $CardColor, $ManaValue }

        }
        $params = @{
            Uri         = 'https://api.scryfall.com/cards/search?{0}' -f $queryString
            Headers     = @{ Accept = '*/*' }
            UserAgent   = 'ManaShell'
            ContentType = 'application/json'
        }

        $cardData = Invoke-RestMethod @params

        return $cardData
    }
}
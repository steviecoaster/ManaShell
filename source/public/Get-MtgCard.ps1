Function Get-MtgCard {
<#
.SYNOPSIS
Retrieves Magic: The Gathering card data from the Scryfall API.

.DESCRIPTION
The `Get-MtgCard` function retrieves Magic: The Gathering card data using the Scryfall API. 
It supports searching for cards by name (exact or fuzzy matching) or retrieving a random card. 
The function can also filter for random cards that are legal as commanders.

.PARAMETER Name
Specifies the name of the card to search for. This parameter is mandatory when using the `search` parameter set.

.PARAMETER Exact
Performs an exact name search for the specified card. This parameter is part of the `search` parameter set.

.PARAMETER Fuzzy
Performs a fuzzy name search for the specified card. This parameter is part of the `search` parameter set.

.PARAMETER Random
Retrieves a random Magic: The Gathering card. This parameter is mandatory when using the `random` parameter set.

.PARAMETER Commander
Filters random cards to only include those that are legal as commanders. This parameter is part of the `random` parameter set.

.PARAMETER Render
If specified, renders the card data visually using the `Show-Card` function.

.OUTPUTS
Returns the card data retrieved from the Scryfall API as a PowerShell object. 
If the `-Render` parameter is specified, the card data is displayed visually instead of being returned.

.EXAMPLE
Get-MtgCard -Name "Black Lotus" -Exact
Searches for the card "Black Lotus" using an exact name match.

.EXAMPLE
Get-MtgCard -Name "Lotus" -Fuzzy
Searches for a card with a name similar to "Lotus" using fuzzy matching.

.EXAMPLE
Get-MtgCard -Random
Retrieves a random Magic: The Gathering card.

.EXAMPLE
Get-MtgCard -Random -Commander
Retrieves a random Magic: The Gathering card that is legal as a commander.

.EXAMPLE
Get-MtgCard -Name "Black Lotus" -Exact -Render
Searches for the card "Black Lotus" using an exact name match and renders the card visually.

.NOTES
- This function uses the Scryfall API to fetch card data.
- Ensure you have an active internet connection to use this function.
- The `Invoke-RestMethod` cmdlet is used to send the API request.
#>
    [CmdletBinding(HelpUri = 'https://steviecoaster.githubpages.io/ManaShell/Get-MtgCard/')]
    Param(
        [Parameter(Mandatory, ParameterSetName = 'search')]
        [String]
        $Name,

        [Parameter(ParameterSetName = 'search')]
        [Switch]
        $Exact,

        [Parameter(ParameterSetName = 'search')]
        [Switch]
        $Fuzzy,

        [Parameter(Mandatory, ParameterSetName = 'random')]
        [Switch]
        $Random,

        [Parameter(ParameterSetName = 'random')]
        [Switch]
        $Commander, 

        [Parameter()]
        [Switch]
        $Render
    )

    $headers = @{
        Accept = '*/*'
    }

    switch ($PSCmdlet.ParameterSetName) {
        'random' {
            $uri = 'https://api.scryfall.com/cards/random'
            if ($Commander) {
                $quertyString = New-QueryString -QueryParameter @{q = 'is:commander' }
                $uri = '{0}?{1}' -f $uri, $quertyString
            }

            $params = @{
                Uri         = $uri
                Headers     = $headers
                UserAgent   = 'ManaShell'
                ContentType = 'application/json'
            }

            $cardData = Invoke-RestMethod @params

            if (-not $Render) {
                return $cardData
            }
            else {
                Show-Card -CardData $cardData
            }
        }

        'search' {

            $uri = 'https://api.scryfall.com/cards/named'

            if ($Exact) { 
                $quertyString = New-QueryString -QueryParameter @{exact = $Name }
            }

            if ($fuzzy) {
                $quertyString = New-QueryString -QueryParameter @{fuzzy = $Name }
            }

            if ($Exact -and $Fuzzy) {
                throw 'Only one of -Fuzzy and -Exact may be provided!'
            }

            $uri = '{0}?{1}' -f $uri, $quertyString

            $params = @{
                Uri         = $uri
                Headers     = $headers
                UserAgent   = 'ManaShell'
                ContentType = 'application/json'
            }

            $cardData = Invoke-RestMethod @params

            return $cardData
        }
    }
}
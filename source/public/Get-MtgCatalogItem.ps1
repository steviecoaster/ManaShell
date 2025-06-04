function Get-MtgCatalogItem {
    <#
    .SYNOPSIS
    Retrieves catalog data from the Scryfall API for a specific Magic: The Gathering category.
    
    .DESCRIPTION
    The `Get-MtgCatalogItem` function retrieves catalog data from the Scryfall API for a specified category. 
    The available categories include card names, artist names, supertypes, card types, and more. 
    The function returns the catalog data as an array of strings.
    
    .PARAMETER Item
    Specifies the catalog category to retrieve. 
    The valid categories are:
    - `card-names`
    - `artist-names`
    - `word-bank`
    - `supertypes`
    - `card-types`
    - `artifact-types`
    - `battle-types`
    - `creature-types`
    - `enchantment-types`
    - `land-types`
    - `planeswalker-types`
    - `spell-types`
    - `powers`
    - `toughness`
    - `loyalties`
    - `keyword-abilities`
    - `keyword-actions`
    - `ability-words`
    - `flavor-words`
    - `watermarks`
    
    This parameter is mandatory and must be one of the predefined categories.
    
    .OUTPUTS
    Returns the catalog data retrieved from the Scryfall API as an array of strings.
    
    .EXAMPLE
    Get-MtgCatalogItem -Item "card-names"
    Retrieves a list of all card names from the Scryfall API.
    
    .EXAMPLE
    Get-MtgCatalogItem -Item "artist-names"
    Retrieves a list of all artist names from the Scryfall API.
    
    .EXAMPLE
    Get-MtgCatalogItem -Item "creature-types"
    Retrieves a list of all creature types from the Scryfall API.
    
    .NOTES
    - This function uses the Scryfall API to fetch catalog data.
    - Ensure you have an active internet connection to use this function.
    - The `Invoke-RestMethod` cmdlet is used to send the API request.
    
    #>
    [CmdletBinding(HelpUri = 'https://steviecoaster.github.io/ManaShell/Commands/Get-MtgCatalogItem/')]
    Param(
        [Parameter(Mandatory)]
        [String]
        [ValidateSet('card-names',
        'artist-names',
        'word-bank',
        'supertypes',
        'card-types',
        'artifact-types',
        'battle-types',
        'creature-types',
        'enchantment-types',
        'land-types',
        'planeswalker-types',
        'spell-types',
        'powers',
        'toughness',
        'loyalties',
        'keyword-abilities',
        'keyword-actions',
        'ability-words',
        'flavor-words',
        'watermarks')]
        $Item
    )

    end {
        $params = @{
            Uri         = 'https://api.scryfall.com/catalog/{0}' -f $Item
            Headers     = @{ Accept = '*/*' }
            UserAgent   = 'ManaShell'
            ContentType = 'application/json'
        }

         (Invoke-RestMethod @params).data
    }
}
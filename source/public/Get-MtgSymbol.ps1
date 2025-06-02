function Get-MtgSymbol {
<#
.SYNOPSIS
Retrieves Magic: The Gathering symbols from the Scryfall API.

.DESCRIPTION
The `Get-MtgSymbol` function fetches all Magic: The Gathering symbols from the Scryfall API. 
It can return the full symbol data or filter for a specific symbol if the `-Symbol` parameter is provided.

.PARAMETER Symbol
Specifies a particular symbol to filter the results. 
If this parameter is provided, only the matching symbol's data will be returned.

.OUTPUTS
If the `-Symbol` parameter is provided, the function returns the specific symbol's data.
If no parameter is provided, the function returns all available symbols as an array of objects.

.EXAMPLE
Get-MtgSymbol
Retrieves all Magic: The Gathering symbols from the Scryfall API.

.EXAMPLE
Get-MtgSymbol -Symbol "{W}"
Retrieves data for the white mana symbol.

.NOTES
- This function uses the Scryfall API to fetch symbol data.
- Ensure you have an active internet connection to use this function.
- The `Invoke-RestMethod` cmdlet is used to send the API request.

.LINK
https://scryfall.com/docs/api
#>
    [CmdletBinding(HelpUri = 'https://steviecoaster.githubpages.io/ManaShell/Get-MtgSymbol/')]
    Param(
        [Parameter()]
        [String]
        $Symbol
    )

    end {
        $params = @{
            Uri         = 'https://api.scryfall.com/symbology'
            Headers     = @{ Accept = '*/*' }
            UserAgent   = 'ManaShell'
            ContentType = 'application/json'
        }

        $cardData = (Invoke-RestMethod @params).data

        if($Symbol) {
            $cardData.symbol
        }
        else {
            $cardData
        }
    }
}
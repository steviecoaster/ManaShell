function Get-MtgSet {
<#
.SYNOPSIS
Retrieves Magic: The Gathering set data from the Scryfall API.

.DESCRIPTION
The `Get-MtgSet` function retrieves Magic: The Gathering set data using the Scryfall API. 
It supports retrieving a specific set by its code or ID, or fetching all available sets.

.PARAMETER Code
Specifies the unique three- or four-character code of the set to retrieve. 
For example, "LEA" for Limited Edition Alpha.

.PARAMETER Id
Specifies the unique Scryfall ID of the set to retrieve.

.OUTPUTS
If a specific set is requested (using `-Code` or `-Id`), the function returns the set data as a PowerShell object.
If no specific set is requested, the function returns an array of all available sets.

.EXAMPLE
Get-MtgSet -Code "LEA"
Retrieves data for the set "Limited Edition Alpha" using its code.

.EXAMPLE
Get-MtgSet -Id "12345678-1234-1234-1234-1234567890ab"
Retrieves data for a set using its unique Scryfall ID.

.EXAMPLE
Get-MtgSet
Retrieves data for all Magic: The Gathering sets.

.NOTES
- This function uses the Scryfall API to fetch set data.
- Ensure you have an active internet connection to use this function.
- The `Invoke-RestMethod` cmdlet is used to send the API request.
- Only one of the parameters `-Code` or `-Id` can be used at a time.

#>
    [CmdletBinding(HelpUri = 'https://steviecoaster.github.io/ManaShell/Commands/Get-MtgSet/')]
    Param(
        [Parameter()]
        [String]
        $Code,

        <# This appears in the api documentation, however the tcgplayer_id property is not
            on a returned object via the sets api, so I cannot use this (at least currently)
        [Parameter()]
        [String]
        $TcgPlayerId,
        #>
        
        [Parameter()]
        [String]
        $Id
    )

    begin {
        # Fix this later, so that common parameters can be used (-Verbose, -Debug, etc)
        if ($PSBoundParameters.Count -gt 1) {
            throw 'Only one of -Code, -TcgPlayerId, and -Id are allowed!'
        }
    }
    end {
        $options = if ($PSBoundParameters['Code']) {
            @{
                uri        = 'https://api.scryfall.com/sets/{0}' -f $Code
                SingleItem = $true
            }
        }
        # This will never be hit yet due to a limitation of the api
        elseif ($PSBoundParameters['TcgPlayerId']) { 
            @{
                uri        = 'https://api.scryfall.com/sets/tcgplayer/{0}' -f $TcgPlayerId
                SingleItem = $true
            }
        }
        elseif ($PSBoundParameters['Id']) {
            @{
                uri        = 'https://api.scryfall.com/sets/{0}' -f $Id
                SingleItem = $true
            } 
            
        }
        else { 
            @{
                uri        = 'https://api.scryfall.com/sets'
                SingleItem = $false
            }
            
        }

        $params = @{
            Uri         = $options['uri']
            Headers     = @{ Accept = '*/*' }
            UserAgent   = 'ManaShell'
            ContentType = 'application/json'
        }

        $cardData = Invoke-RestMethod @params

        if ($options['SingleItem']) {
            $cardData
        }
        else {
            $cardData.data
        }
    }
}

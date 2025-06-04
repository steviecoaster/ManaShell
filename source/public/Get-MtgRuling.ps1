function Get-MtgRuling {
    <#
    .SYNOPSIS
    Retrieves rulings for a Magic: The Gathering card from the Scryfall API.
    
    .DESCRIPTION
    The `Get-MtgRuling` function retrieves rulings for a Magic: The Gathering card using the Scryfall API. 
    Rulings provide official clarifications or errata for cards. The function supports multiple ways to identify a card, 
    including Multiverse ID, MTGO ID, Scryfall ID, Arena ID, or a combination of set code and collector number.
    
    .PARAMETER MultiverseId
    Specifies the Multiverse ID of the card to retrieve rulings for.
    
    .PARAMETER MtgoId
    Specifies the MTGO ID of the card to retrieve rulings for.
    
    .PARAMETER ScryfallId
    Specifies the Scryfall ID of the card to retrieve rulings for.
    
    .PARAMETER ArenaId
    Specifies the Arena ID of the card to retrieve rulings for.
    
    .PARAMETER SetCode
    Specifies the set code of the card to retrieve rulings for. This parameter is mandatory when using the `Set` parameter set.
    
    .PARAMETER CollectorNumber
    Specifies the collector number of the card within the set. This parameter is mandatory when using the `Set` parameter set.
    
    .OUTPUTS
    Returns the rulings for the specified card as a PowerShell object.
    
    .EXAMPLE
    Get-MtgRuling -MultiverseId 12345
    Retrieves rulings for the card with the specified Multiverse ID.
    
    .EXAMPLE
    Get-MtgRuling -MtgoId 67890
    Retrieves rulings for the card with the specified MTGO ID.
    
    .EXAMPLE
    Get-MtgRuling -ScryfallId "abcdef12-3456-7890-abcd-ef1234567890"
    Retrieves rulings for the card with the specified Scryfall ID.
    
    .EXAMPLE
    Get-MtgRuling -ArenaId 54321
    Retrieves rulings for the card with the specified Arena ID.
    
    .EXAMPLE
    Get-MtgRuling -SetCode "LEA" -CollectorNumber "1"
    Retrieves rulings for the card with collector number 1 in the "Limited Edition Alpha" set.
    
    .NOTES
    - This function uses the Scryfall API to fetch rulings data.
    - Ensure you have an active internet connection to use this function.
    - The `Invoke-RestMethod` cmdlet is used to send the API request.
    
    #>
    [CmdletBinding(HelpUri = 'https://steviecoaster.github.io/ManaShell/Commands/Get-MtgRuling/', DefaultParameterSetName = 'default')]
    Param(
        [Parameter()]
        [String]
        $MultiverseId,

        [Parameter()]
        [String]
        $MtgoId,

        [Parameter()]
        [String]
        $ScryfallId,

        [Parameter()]
        [String]
        $ArenaId,

        [Parameter(Mandatory, ParameterSetName = 'Set')]
        [ArgumentCompleter( {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

                # Fetch set codes from the catalog
                $setCodes = (Get-MtgSet).code

                # Filter by set code
                $setCodes | Where-Object { $_ -like "$WordToComplete*" } | ForEach-Object {
                
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Magic: The Gathering card name: $_")
                }
            }
        )]

        [String]
        $SetCode,

        [Parameter(Mandatory, ParameterSetName = 'Set')]
        [String]
        $CollectorNumber
    )

    end {

        
        $uri = switch ($PSCmdlet.ParameterSetName) {
            'Set' {
                'https://api.scryfall.com/cards/{0}/{1}/rulings' -f $SetCode, $CollectorNumber
            }

            default {
                switch ($true) {
                    $PSBoundParameters.ContainsKey('MultiverseId') { 'https://api.scryfall.com/cards/multiverse/{0}/rulings' -f $MultiverseId }
                    $PSBoundParameters.ContainsKey('MtgoId') { 'https://api.scryfall.com/cards/mtgo/{0}/rulings' -f $MtgoId }
                    $PSBoundParameters.ContainsKey('ScryfallId') { 'https://api.scryfall.com/cards/{0}/rulings' -f $ScryfallId }
                    $PSBoundParameters.ContainsKey('ArenaId') { 'https://api.scryfall.com/cards/arena/{0}/rulings' -f $ArenaId }
                }
        
            }
        }      
        
        $params = @{
            Uri         = $uri
            Headers     = $headers
            UserAgent   = 'ManaShell'
            ContentType = 'application/json'
        }

       (Invoke-RestMethod @params).data
    }
}
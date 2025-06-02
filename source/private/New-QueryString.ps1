function New-QueryString {
    <#
    .SYNOPSIS
    Turn a hashtable into a URI querystring
    
    .DESCRIPTION
    Turn a hashtable into a URI querystring
    
    .PARAMETER QueryParameter
    The hashtable to transform
    
    .EXAMPLE
    New-QueryString -QueryParameter @{ Animal = 'Dog'; Breed = 'Labrador'; Name = 'Dilbert'}
    
    .EXAMPLE
    New-QueryString -QueryParameter @{ Animal = 'Dog'; Breed = 'Labrador', 'Retriever'; Name = 'Dilbert'}
    
    .EXAMPLE
    New-QueryString -QueryParameter ([ordered]@{ Animal = 'Dog'; Breed = 'Labrador', 'Retriever'; Name = 'Dilbert'})
    
    .NOTES
    Shamelessly taken from https://powershellmagazine.com/2019/06/14/pstip-a-better-way-to-generate-http-query-strings-in-powershell/
    #>
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]
        $QueryParameter
    )
    # Add System.Web
    Add-Type -AssemblyName System.Web
    
    # Create a http name value collection from an empty string
    $nvCollection = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    
    foreach ($key in $QueryParameter.Keys) {
        if ($QueryParameter[$key].GetType().ImplementedInterfaces.Contains([System.Collections.ICollection])) {
            foreach ($record in $QueryParameter[$key]) {
                $nvCollection.Add($key, $record)
            }
        } else {
            $nvCollection.Add($key, $QueryParameter.$key)
        }
    }
    
    return $nvCollection.ToString()
}
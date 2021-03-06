﻿<# 
 .Synopsis
  Get Best Nav Container Image Name
 .Description
  If a Container Os platform name is not specified in the imageName, find the best container os and add it (if his is a microsoft image)
 .Parameter imageName
  Name of image
 .Example
  $imageName = Get-BestNavContainerImageName -imageName $imageName
#>
function Get-BestNavContainerImageName {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline)]
        [string]$imageName
    )

    if (!$imageName.Contains(':')) {
        $imageName += ":latest"
    }

    if (($imagename.StartsWith('microsoft/') -or 
         $imagename.StartsWith('bcinsider.azurecr.io/') -or 
         $imagename.StartsWith('mcr.microsoft.com/') -or 
         $imagename.StartsWith('mcrbusinesscentral.azurecr.io/')) -and 
        ($imagename.Substring($imagename.Length-8,4) -ne "ltsc")) {
            # If we are using a Microsoft image without specific containeros - add best container tag

            $hostOsVersion = [System.Environment]::OSVersion.Version
            $bestContainerOs = "ltsc2016"
            if ($hostOsVersion.Major -eq 10 -and $hostOsVersion.Minor -eq 0 -and $hostOsVersion.Build -ge 17763) { 
                $bestContainerOs = "ltsc2019"
            }
        
            $imageName += "-$bestContainerOs"
    }

    $imageName
}
Export-ModuleMember -function Get-BestNavContainerImageName

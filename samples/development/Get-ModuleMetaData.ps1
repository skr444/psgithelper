<#
    .SYNOPSIS
    Creates a list of the specified elements.

    .DESCRIPTION
    Can be used to update the module meta data after new files have been added or existing files have been altered.

    .PARAMETER MetaData
    Which kind of meta data to generate.

    .INPUTS
    Does not take any inputs via pipeline.

    .OUTPUTS
    The specified list of elements formatted for copy-pasting into the target location.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateSet("FileList", "FunctionList", "DotSourceList")]
    [string]
    $MetaData = "FileList"
)

$VerbosePreference = "Continue"

[System.IO.FileInfo]$SourcePath = Join-Path -Path ($PSCommandPath | Split-Path -Parent) `
                                -ChildPath ".." `
                                -AdditionalChildPath @("..", "src")


switch ($MetaData) {
    "FileList" {
        $items = Get-ChildItem -Path $SourcePath -File | Select-Object -Property Name `
            | ForEach-Object { "'$($_.Name)'" }
        
        [string]::Join(",$([System.Environment]::NewLine)", $items)
    }

    "FunctionList" {
        $items = Get-ChildItem -Path $SourcePath -File `
            | Where-Object { ($_ | Get-Content -ReadCount 1) -imatch "function .+\-.+ \{" } `
            | ForEach-Object { "'$($_.Name)'" -replace ".ps1", "" }
        
        [string]::Join(",$([System.Environment]::NewLine)", $items)
    }

    "DotSourceList" {
        $items = @()
        $items += Get-ChildItem -Path $SourcePath `
            | Where-Object { $_.Name.EndsWith(".ps1") -and (-not $_.Name.StartsWith("Shared")) } `
            | ForEach-Object { ". `$PSScriptRoot\$($_.Name)" }
        
        [string]::Join("$([System.Environment]::NewLine)", $items)
    }

    Default {
        throw "Unsupported `$MetaData value: '${MetaData}'."
    }
}

<#
    .SYNOPSIS
    Simplistic build script.

    .DESCRIPTION
    More information about Powershell repositories and how to register them for publishing,
    see https://docs.microsoft.com/en-us/powershell/module/powershellget/?view=powershell-7.2

    .NOTES
    This script is intended to be invoked from the repository root directory.
#>

[CmdletBinding(DefaultParameterSetName = "Build")]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $ModuleName = "PSGitHelper",

    [string]
    [Parameter(Mandatory = $false)]
    $SourceDirectory = (Join-Path $PSScriptRoot "src"),

    [string]
    [Parameter(Mandatory = $false)]
    $BuildDirectory = (Join-Path $PSScriptRoot "build"),

    [Parameter(Mandatory = $false)]
    [switch]
    $SkipPesterTests,

    [string]
    [Parameter(Mandatory = $false, ParameterSetName = "Publish")]
    $Repository = "PSGallery",

    [string]
    [Parameter(Mandatory = $true, ParameterSetName = "Publish")]
    $NugetApiKey,

    [switch]
    [Parameter(Mandatory = $false, ParameterSetName = "Publish")]
    $Publish
)

function Confirm-ModuleManifest {
    <#
        .DESCRIPTION
        Validates the module manifest file and extracts the module version.
        Returns the module version.
    #>
    param (
        $SourceFolder,
        $Module
    )

    Write-Verbose "Evaluating module manifest.."
    $manifestFile = $SourceFolder | Join-Path -ChildPath ("{0}.psd1" -f $Module)
    $manifest = Test-ModuleManifest -Path $manifestFile
    $version = $manifest.Version.ToString()
    Write-Verbose "Module version evaluated to '${version}'."
    if ($manifest.Name -ne $Module) {
        $errorMessage = @(
            "Module name mismatch.",
            "Name from manifest: '$($manifest.Name)'.",
            "Name from ModuleName parameter: '${Module}'.",
            "Please update either one to match the other."
        )
        throw ($errorMessage -join " ")
    }

    return $version
}

$VerbosePreference = "Continue"

if (-not $SkipPesterTests) {
    $testResults = Invoke-Pester -PassThru
    
    if (($testResults.Result -ne "passed") -or ($testResults.FailedCount -ne 0)) {
        throw "$($testResults.FailedCount) pester test/s failed. Test result was: '$($testResults.Result)'."
    }
}

$version = Confirm-ModuleManifest -SourceFolder $SourceDirectory -Module $ModuleName

$outputDirectory = Join-Path $BuildDirectory $ModuleName $version

if (Test-Path -Path $outputDirectory) {
    Write-Verbose "Clearing '${outputDirectory}'.."
    Remove-Item -Path $outputDirectory -Recurse -Force | Out-Null
}

Write-Verbose "Creating '${outputDirectory}'.."
New-Item -Path $outputDirectory -ItemType Directory | Out-Null

Write-Verbose "Copying module scripts to '${outputDirectory}'.."
Copy-Item -Path ($SourceDirectory | Join-Path -ChildPath "*") -Destination $outputDirectory -Recurse | Out-Null

if ($Publish) {
    Publish-Module -Path $outputDirectory `
        -Repository $Repository `
        -NuGetApiKey $NugetApiKey `
        -Verbose
}

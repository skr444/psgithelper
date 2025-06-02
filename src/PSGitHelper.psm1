<#
    .SYNOPSIS
    PSGitHelper Powershell module main file.

    .DESCRIPTION
    Module entry point containing the logic that is executed when
    the module is imported into the session with Import-Module.
#>

#Requires -Version 5
Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
#$VerbosePreference = "Continue"

. $PSScriptRoot\Get-GitStatus.ps1
. $PSScriptRoot\New-GitWipCommit.ps1
. $PSScriptRoot\Remove-OrphanedLocalBranches.ps1
. $PSScriptRoot\Update-LocalGitRepository.ps1

$exportModuleMemberParams = @{
    Function = @(
        'Get-GitStatus',
        'New-GitWipCommit',
        'Remove-OrphanedLocalBranches',
        'Update-LocalGitRepository'
    )
    Variable = @()
    Alias = "*"
}

Export-ModuleMember @exportModuleMemberParams

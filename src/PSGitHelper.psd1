@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'PSGitHelper.psm1'
    
    # Version number of this module.
    ModuleVersion = '1.0.2'
    
    # ID used to uniquely identify this module
    GUID = '227f1063-8b0d-45ea-b385-08e1c30e9d2e'

    # Author of this module
    Author = 'skr444'

    # Copyright statement for this module
    Copyright = 'Copyright © skr444 2025'
    
    # Description of the functionality provided by this module
    Description = 'A collection of scripts aimed to increase the convenience of using Git in Powershell.'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    FileList = @(
        'Get-GitStatus.ps1',
        'PSGitHelper.psd1',
        'PSGitHelper.psm1',
        'New-GitWipCommit.ps1',
        'Remove-OrphanedLocalBranches.ps1',
        'Update-LocalGitRepository.ps1'
    )

    # Functions to export from this module
    FunctionsToExport = @(
        'Get-GitStatus',
        'New-GitWipCommit',
        'Remove-OrphanedLocalBranches',
        'Update-LocalGitRepository'
    )

    # Cmdlets to export from this module
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module
    AliasesToExport = "*"
}

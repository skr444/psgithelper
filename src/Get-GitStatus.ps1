function Get-GitStatus {
    <#
        .SYNOPSIS
        Performs 'git status'.

        .DESCRIPTION
        Performs 'git status'.
    #>
    [Alias("gist", "gstat")]
    [CmdletBinding()]
    param ()

    git status
}

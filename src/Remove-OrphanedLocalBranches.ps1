function Remove-OrphanedLocalBranches {
    <#
        .SYNOPSIS
        Prunes orphaned local branches.

        .DESCRIPTION
        Deletes local branches that have no remote tracking branch.

        .PARAMETER List
        Only lists the local orphaned branches without deleting them when specified.

        .INPUTS
        None.

        .OUTPUTS
        None.
    #>

    [Alias("gitprunelocals", "gpl", "rob")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Alias("L", "Show")]
        [switch]
        $List
    )

    [string[]]$locals = (git branch -l) | ForEach-Object { [string]($_ -replace "\*", "").Trim() }
    Write-Verbose "Local branches:"
    $locals | ForEach-Object { Write-Verbose $_ }
    Write-Verbose ""

    [string[]]$remotes = (git branch -r) | ForEach-Object { [string](($_ -replace "remotes/", "") -replace "origin/", "").Trim() }
    Write-Verbose "Remotes:"
    $remotes | ForEach-Object { Write-Verbose $_ }
    Write-Verbose ""

    if ($List) {
        Write-Output "Branches to delete:"
    }

    foreach($branch in $locals) {
        if (-not ($remotes -contains $branch)) {
            if ($List) {
                Write-Output "${branch}"
            } else {
                Write-Verbose "Deleting branch '${branch}'.."
                git branch -D $branch
            }
        }
    }
}

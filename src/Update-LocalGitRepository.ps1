function Update-LocalGitRepository {
    <#
        .SYNOPSIS
        Performs 'git fetch --all --prune'.

        .DESCRIPTION
        Performs 'git fetch --all --prune'.

        .PARAMETER PruneTags
        Also prunes local tags when specified.
    #>

    [Alias("gfa")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Alias("pt")]
        [switch]
        $PruneTags
    )

    $gitFetchArgs = @(
        "fetch",
        "--all",
        "--prune"
    )

    if ($PruneTags) {
        $gitFetchArgs += "--prune-tags"
    }

    Write-Verbose "Fetching with args: ${gitFetchArgs}"
    git @gitFetchArgs
}

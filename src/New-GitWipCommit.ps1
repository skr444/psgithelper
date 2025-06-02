function New-GitWipCommit {
    <#
        .SYNOPSIS
        Saves the current state in git.

        .DESCRIPTION
        Stages all file changes, creates a commit and pushes to remote if possible.

        .PARAMETER Path
        Specifies the repository path.
        Uses the current directory when omitted.

        .PARAMETER Message
        The commit message to use.
        Uses 'wip' when omitted.

        .PARAMETER LocalOnly
        Does not push the commit when specified.
        Helpful when only a local commit should be created.

        .INPUTS
        Does not accept input from the pipeline.

        .OUTPUTS
        Writes the git command output to stdout.
    #>
    
    [Alias("wip")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [Alias("P")]
        [string]
        $Path = ".",

        [Parameter(Mandatory = $false)]
        [Alias("M")]
        [string]
        $Message = "wip",

        [Parameter(Mandatory = $false)]
        [Alias("Lo")]
        [switch]
        $LocalOnly
    )

    $gitAddArgs = @(
        "add",
        $Path
    )
    Write-Verbose "Adding with args: ${gitAddArgs}"
    git @gitAddArgs
    
    $gitCommitArgs = @(
        "commit",
        "-m",
        $Message
    )
    Write-Verbose "Committing with args: ${gitCommitArgs}"
    git @gitCommitArgs

    if (-not $LocalOnly) {
        if (git config --local --get remote.origin.url) {
            Write-Verbose "Pushing to origin.."
            git push origin
        } else {
            Write-Verbose "Not pushing because local repo."
        }
    }
}

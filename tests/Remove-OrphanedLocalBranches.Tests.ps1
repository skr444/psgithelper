BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('tests', 'src')
}

Describe "Remove-OrphanedLocalBranches" {
    Context "Normal invocation with orphaned local branches" {
        It "Removes orphaned local branches" {
            Mock -CommandName git -MockWith {
                if ($args -icontains "-l") {
                    return @("a-branch")
                }
                elseif ($args -icontains "-r") {
                    return @("")
                }
                elseif ($args -icontains "-D") {
                    return ""
                } else {
                    return ""
                }
            }

            Remove-OrphanedLocalBranches
            Assert-MockCalled -CommandName git -Times 3 -Exactly
        }
    }

    Context "Normal invocation without orphaned local branches" {
        It "Does nothing" {
            Mock -CommandName git -MockWith {
                if ($args -icontains "-l") {
                    return @("a-branch")
                }
                elseif ($args -icontains "-r") {
                    return @("remotes/origin/a-branch")
                }
                elseif ($args -icontains "-D") {
                    return ""
                } else {
                    return ""
                }
            }

            Remove-OrphanedLocalBranches
            Assert-MockCalled -CommandName git -Times 2 -Exactly
        }
    }

    Context "List only" {
        It "Lists orphaned branches" {
            Mock -CommandName git -MockWith {
                if ($args -icontains "-l") {
                    return @("a-branch")
                }
                elseif ($args -icontains "-r") {
                    return @("")
                }
                elseif ($args -icontains "-D") {
                    return ""
                } else {
                    return ""
                }
            }
            Mock -CommandName Write-Output -MockWith { return }

            Remove-OrphanedLocalBranches -List
            Assert-MockCalled -CommandName git -Times 2 -Exactly
            Assert-MockCalled -CommandName Write-Output -Times 2 -Exactly
        }
    }
}

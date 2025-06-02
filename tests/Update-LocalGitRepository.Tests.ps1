BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('tests', 'src')
}

Describe "Update-LocalGitRepository" {
    Context "Normal invocation" {
        It "Performs git fetch" {
            Mock -CommandName git -MockWith {
                $args.Count | Should -BeExactly 3
                $args[0] | Should -BeExactly "fetch"
                $args[1] | Should -BeExactly "--all"
                $args[2] | Should -BeExactly "--prune"
            }

            Update-LocalGitRepository
            Assert-MockCalled -CommandName git -Times 1 -Exactly
        }
    }

    Context "Normal invocation prune tags" {
        It "Performs git fetch with the prune tags switch" {
            Mock -CommandName git -MockWith {
                $args.Count | Should -BeExactly 4
                $args[0] | Should -BeExactly "fetch"
                $args[1] | Should -BeExactly "--all"
                $args[2] | Should -BeExactly "--prune"
                $args[3] | Should -BeExactly "--prune-tags"
            }

            Update-LocalGitRepository -PruneTags
            Assert-MockCalled -CommandName git -Times 1 -Exactly
        }
    }
}

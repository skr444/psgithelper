BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('tests', 'src')
}

Describe "New-GitWipCommit" {
    Context "Normal invocation with default values" {
        It "Performs git add, git commit and git push" {
            Mock -CommandName git -MockWith {
                if ($args -icontains "add") {
                    $args[1] | Should -BeExactly "."
                    return
                }
                if ($args -icontains "commit") {
                    $args[1] | Should -BeExactly "-m"
                    $args[2] | Should -BeExactly "wip"
                    return
                }
                if ($args -icontains "config") {
                    return "remote-origin-url"
                }
                if ($args -icontains "push") {
                    return
                }
            }

            New-GitWipCommit
            Assert-MockCalled -CommandName git -Times 4 -Exactly
        }
    }

    Context "Normal invocation with default values and no remote" {
        It "Performs git add and git commit" {
            Mock -CommandName git -MockWith {
                if ($args -icontains "add") {
                    $args[1] | Should -BeExactly "."
                    return
                }
                if ($args -icontains "commit") {
                    $args[1] | Should -BeExactly "-m"
                    $args[2] | Should -BeExactly "wip"
                    return
                }
                if ($args -icontains "config") {
                    return
                }
            }

            New-GitWipCommit
            Assert-MockCalled -CommandName git -Times 3 -Exactly
        }
    }

    Context "Normal invocation with default values and local only switch" {
        It "Performs git add and git commit" {
            Mock -CommandName git -MockWith {
                if ($args -icontains "add") {
                    $args[1] | Should -BeExactly "."
                    return
                }
                if ($args -icontains "commit") {
                    $args[1] | Should -BeExactly "-m"
                    $args[2] | Should -BeExactly "wip"
                    return
                }
            }

            New-GitWipCommit -LocalOnly
            Assert-MockCalled -CommandName git -Times 2 -Exactly
        }
    }
}

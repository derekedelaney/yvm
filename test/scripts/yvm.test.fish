#!/usr/bin/env fish

set GREEN '\033[0;32m'
set RED '\033[0;31m'
set NC '\033[0m' # No Color

function testing
    echo
    echo
    echo -e "$GREEN>>> $argv $NC"
end

function pass
    echo -e "$GREEN PASSED! $NC"
end

function fail
    echo -e "$RED TEST FAILED! $NC"
    echo "Test output::"
    echo $argv
    exit 1
end

testing "yvm default options"
~/.yvm/yvm.fish --version
if test $status -eq 0
    pass
else
    fail "yvm --version non zero exit"
end

~/.yvm/yvm.fish --help
if test $status -eq 0
    pass
else
    fail "yvm --help non zero exit"
end

testing "yvm set default version"
~/.yvm/yvm.fish set-default 1.12.0
source ~/.yvm/yvm.fish

testing "yvm exec alias version"
set test0_output (yvm exec default --version)
if test "$test0_output" = "1.12.0"
    pass
else
    fail "$test0_output"
end

testing "yvm install version"
yvm install 1.11.0
testing "yvm exec version command"
set test1_output (yvm exec 1.11.0 --version)
if test "$test1_output" = "1.11.0"
    pass
else
    fail $test1_output
end

testing "yarn shimmed config"
set test_shim_config_output (yarn --version)
if test "$test_shim_config_output" = "1.16.0"
    pass
else
    fail $test_shim_config_output
end

testing "yvm use"
yvm install 1.13.0
yvm use 1.13.0
set test2_output (yvm exec --version)
if test "$test2_output" = "1.16.0"
    pass
else
    fail $test2_output
end

testing "yvm use set yarn"
set test3_output (yarn --version)
if test "$test3_output" = "1.13.0"
    pass
else
    fail $test3_output
end

testing "yvm uninstall version"
yvm uninstall 1.11.0
if test $status -eq 0
    pass
else
    fail "yvm uninstall 1.11.0 failed"
end

testing "yvm uninstall alias version"
yvm uninstall default
if test $status -eq 0
    pass
else
    fail "yvm uninstall default failed"
end

testing "yvm current command"
set test4_output (yvm current)
if test "$test4_output" = "1.13.0"
    pass
else
    fail "yvm current command failed: $test4_output"
end

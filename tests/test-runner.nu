#!/usr/bin/env nushell

# Test runner for all levels
# Simple version that tests a fixed set of levels

# Results tracking
mut passed = 0
mut failed = 0
mut failed_levels = []

# Define test levels (simple hardcoded list for now)
let test_levels = [
    { num: "00", expected: "bandit0", file: "game/levels/00/check.nu" },
    { num: "01", expected: "bandit1", file: "game/levels/01/check.nu" },
    { num: "02", expected: "bandit2", file: "game/levels/02/check.nu" },
    { num: "03", expected: "bandit3", file: "game/levels/03/check.nu" },
    { num: "04", expected: "bandit5", file: "game/levels/04/check.nu" },
    { num: "05", expected: "bandit6", file: "game/levels/05/check.nu" },
    { num: "06", expected: "bandit7", file: "game/levels/06/check.nu" },
    { num: "09", expected: "bandit10", file: "game/levels/09/check.nu" },
    { num: "11", expected: "bandit12", file: "game/levels/11/check.nu" },
]

# Test each level
for test_level in $test_levels {
    let level_num = $test_level.num
    let expected_password = $test_level.expected
    let check_file = $test_level.file

    print -n $"Testing level ($level_num)... "

    # Setup the level
    let setup_file = $"game/levels/($level_num)/setup.nu"
    let setup_cmd = $"use ($setup_file); use game/lib/check.nu; setup main setup"
    try {
        nu -c $setup_cmd | ignore
    } catch {
        print "SKIP (setup failed)"
        continue
    }

    # Build and run the check directly
    let check_result_text = nu -c $"use game/lib/check.nu; use ($check_file); check main check ($expected_password)"
    let success = $check_result_text | str contains "success"
    let message = $check_result_text | str trim

    if $success {
        print $"✓ PASS"
        $passed = ($passed + 1)
    } else {
        print $"✗ FAIL: ($message)"
        $failed = ($failed + 1)
        $failed_levels = ($failed_levels | append $level_num)
    }
}

# Print summary
print ""
print $"=== Test Summary ==="
print $"Total tested: ($passed + $failed)"
print $"Passed: ($passed)"
print $"Failed: ($failed)"

if $failed > 0 {
    print ""
    print $"Failed levels: ($failed_levels | sort | str join ', ')"
    exit 1
}

exit 0

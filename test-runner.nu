#!/usr/bin/env nushell
# Test runner for all levels
# Discovers and executes all check.nu scripts

# Get all level directories
let level_dirs = (ls levels | where type == dir | get name | sort)

# Results tracking
mut passed = 0
mut failed = 0
mut failed_levels = []

# Test each level
for level_dir in $level_dirs {
    let level_num = ($level_dir | path basename)
    
    # Skip if check.nu doesn't exist
    let check_file = ($level_dir | path join "check.nu")
    let setup_file = ($level_dir | path join "setup.nu")
    
    let check_exists = ($check_file | path exists)
    let setup_exists = ($setup_file | path exists)
    
    if not $check_exists {
        continue
    }
    
    print -n $"Testing level ($level_num)... "
    
    # Setup the level
    try {
        nu -c $"use ($setup_file); main setup"
    } catch {
        print "SKIP (setup failed)"
        continue
    }
    
    # Run the check with the expected password
    let expected_password = match $level_num {
        "27" => "4cRGHaL3sZmxBaVyFqHgOh6dpzDvjq6n"
        "28" => "56a9d190189b0a7debe49dab5fee5c2e"
        "29" => "ba4e105caeed5e19e973425fe1b0015b"
        "30" => "jN2kgmIDVu4r94XL3CxCoVQa2BFTtDFY"
        "31" => "jN2kgmIDVu4r94XL3CxCoVQa2BFTtDFY"
        _ => $"bandit($level_num)"
    }
    
    try {
        let result = (nu -c $"use ($check_file); use lib/check.nu; main check ($expected_password)" | from json)
        
        if $result.success {
            print $"✓ PASS"
            $passed += 1
        } else {
            print $"✗ FAIL: ($result.message)"
            $failed += 1
            $failed_levels = ($failed_levels | append $level_num)
        }
    } catch {
        print $"✗ FAIL: Error running check"
        $failed += 1
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

#!/usr/bin/env nushell
# Test runner for levels 17-20

# Test level 17
print "Testing level 17..."
use levels/17/setup.nu
setup main setup | ignore
use levels/17/check.nu
let result17 = (check main check "bandit17")
if $result17.success {
    print "✓ Level 17 PASS"
} else {
    print $"✗ Level 17 FAIL: ($result17.message)"
}

# Test level 18
print "Testing level 18..."
use levels/18/setup.nu
setup main setup | ignore
use levels/18/check.nu
let result18 = (check main check "bandit18")
if $result18.success {
    print "✓ Level 18 PASS"
} else {
    print $"✗ Level 18 FAIL: ($result18.message)"
}

# Test level 19
print "Testing level 19..."
use levels/19/setup.nu
setup main setup | ignore
use levels/19/check.nu
let result19 = (check main check "bandit19")
if $result19.success {
    print "✓ Level 19 PASS"
} else {
    print $"✗ Level 19 FAIL: ($result19.message)"
}

# Test level 20
print "Testing level 20..."
use levels/20/setup.nu
setup main setup | ignore
use levels/20/check.nu
let result20 = (check main check "bandit20")
if $result20.success {
    print "✓ Level 20 PASS"
} else {
    print $"✗ Level 20 FAIL: ($result20.message)"
}

print ""
print "All tests complete!"

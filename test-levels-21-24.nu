#!/usr/bin/env nu
# Test runner for levels 21-24
# Simple test runner that doesn't use dynamic imports

use lib/check.nu

# Test level 21
print "Testing level 21..."
use levels/level21/setup.nu
setup main setup | ignore
use levels/level21/check.nu
let result21 = (check main check "bandit21")
if $result21.success {
    print "✓ Level 21 PASS"
} else {
    print $"✗ Level 21 FAIL: ($result21.message)"
}

# Test level 22
print "Testing level 22..."
use levels/level22/setup.nu
setup main setup | ignore
use levels/level22/check.nu
let result22 = (check main check "bandit22")
if $result22.success {
    print "✓ Level 22 PASS"
} else {
    print $"✗ Level 22 FAIL: ($result22.message)"
}

# Test level 23
print "Testing level 23..."
use levels/level23/setup.nu
setup main setup | ignore
use levels/level23/check.nu
let result23 = (check main check "bandit23")
if $result23.success {
    print "✓ Level 23 PASS"
} else {
    print $"✗ Level 23 FAIL: ($result23.message)"
}

# Test level 24
print "Testing level 24..."
use levels/level24/setup.nu
setup main setup | ignore
use levels/level24/check.nu
let result24 = (check main check "bandit24")
if $result24.success {
    print "✓ Level 24 PASS"
} else {
    print $"✗ Level 24 FAIL: ($result24.message)"
}

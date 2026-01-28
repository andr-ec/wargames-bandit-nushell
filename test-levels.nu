#!/usr/bin/env nushell
# Test runner for levels 0-9
# Simple test runner that doesn't use dynamic imports

use lib/check.nu

# Test level 0
print "Testing level 0..."
use levels/00/setup.nu
setup main setup | ignore
use levels/00/check.nu
let result0 = (check main check "bandit0")
if $result0.success {
    print "✓ Level 0 PASS"
} else {
    print $"✗ Level 0 FAIL: ($result0.message)"
}

# Test level 1
print "Testing level 1..."
use levels/01/setup.nu
setup main setup | ignore
use levels/01/check.nu
let result1 = (check main check "bandit1")
if $result1.success {
    print "✓ Level 1 PASS"
} else {
    print $"✗ Level 1 FAIL: ($result1.message)"
}

# Test level 2
print "Testing level 2..."
use levels/02/setup.nu
setup main setup | ignore
use levels/02/check.nu
let result2 = (check main check "bandit2")
if $result2.success {
    print "✓ Level 2 PASS"
} else {
    print $"✗ Level 2 FAIL: ($result2.message)"
}

# Test level 3
print "Testing level 3..."
use levels/03/setup.nu
setup main setup | ignore
use levels/03/check.nu
let result3 = (check main check "bandit3")
if $result3.success {
    print "✓ Level 3 PASS"
} else {
    print $"✗ Level 3 FAIL: ($result3.message)"
}

# Test level 4
print "Testing level 4..."
use levels/04/setup.nu
setup main setup | ignore
use levels/04/check.nu
let result4 = (check main check "bandit5")
if $result4.success {
    print "✓ Level 4 PASS"
} else {
    print $"✗ Level 4 FAIL: ($result4.message)"
}

# Test level 5
print "Testing level 5..."
use levels/05/setup.nu
setup main setup | ignore
use levels/05/check.nu
let result5 = (check main check "bandit6")
if $result5.success {
    print "✓ Level 5 PASS"
} else {
    print $"✗ Level 5 FAIL: ($result5.message)"
}

# Test level 6
print "Testing level 6..."
use levels/06/setup.nu
setup main setup | ignore
use levels/06/check.nu
let result6 = (check main check "bandit7")
if $result6.success {
    print "✓ Level 6 PASS"
} else {
    print $"✗ Level 6 FAIL: ($result6.message)"
}

# Test level 7
print "Testing level 7..."
use levels/07/setup.nu
setup main setup | ignore
use levels/07/check.nu
let result7 = (check main check "9JkI8LZJPUprjaHEQKKnN1LLYtCLKCid")
if $result7.success {
    print "✓ Level 7 PASS"
} else {
    print $"✗ Level 7 FAIL: ($result7.message)"
}

# Test level 8
print "Testing level 8..."
use levels/08/setup.nu
setup main setup | ignore
use levels/08/check.nu
let result8 = (check main check "CjsICidai6JgErcK92M9IGh3qzjJVGjB")
if $result8.success {
    print "✓ Level 8 PASS"
} else {
    print $"✗ Level 8 FAIL: ($result8.message)"
}

# Test level 9
print "Testing level 9..."
use levels/09/setup.nu
setup main setup | ignore
use levels/09/check.nu
let result9 = (check main check "813VXyMr4N5uP1W30wddJy1OknNg30AQ")
if $result9.success {
    print "✓ Level 9 PASS"
} else {
    print $"✗ Level 9 FAIL: ($result9.message)"
}

print ""
print "All tests complete!"

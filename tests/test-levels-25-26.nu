#!/usr/bin/env nushell
# Test runner for levels 25-26

# Test level 25
print "Testing level 25..."
use levels/25/setup.nu
setup main setup | ignore
use levels/25/check.nu
let result25 = (check main check "p7LtJwPWdt3mvKVfFMf7g67zmICG9Vy")
if $result25.success {
    print "✓ Level 25 PASS"
} else {
    print $"✗ Level 25 FAIL: ($result25.message)"
}

# Test level 26
print "Testing level 26..."
use levels/26/setup.nu
setup main setup | ignore
use levels/26/check.nu
let result26 = (check main check "42WbmEO4SR7mvSp1E1pRK91d5FVBQwYt")
if $result26.success {
    print "✓ Level 26 PASS"
} else {
    print $"✗ Level 26 FAIL: ($result26.message)"
}

print ""
print "All tests complete!"

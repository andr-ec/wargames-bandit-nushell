#!/usr/bin/env nushell
# Test runner for levels 13-16

# Test level 13
print "Testing level 13..."
use levels/13/setup.nu
setup main setup | ignore
use levels/13/check.nu
let result13 = (check main check "BfMYroe26WYyilR17jCw3lNAh8vY3rTZ")
if $result13.success {
    print "✓ Level 13 PASS"
} else {
    print $"✗ Level 13 FAIL: ($result13.message)"
}

# Test level 14
print "Testing level 14..."
use levels/14/setup.nu
setup main setup | ignore
use levels/14/check.nu
let result14 = (check main check "8xc9jcnGj82mq291qPNq8ltlQX9i5fE1")
if $result14.success {
    print "✓ Level 14 PASS"
} else {
    print $"✗ Level 14 FAIL: ($result14.message)"
}

# Test level 15
print "Testing level 15..."
use levels/15/setup.nu
setup main setup | ignore
use levels/15/check.nu
let result15 = (check main check "4wpMlaU4S7rYlDo79Ubu6x32QPz7dnt2")
if $result15.success {
    print "✓ Level 15 PASS"
} else {
    print $"✗ Level 15 FAIL: ($result15.message)"
}

# Test level 16
print "Testing level 16..."
use levels/16/setup.nu
setup main setup | ignore
use levels/16/check.nu
let result16 = (check main check "xjLTmQgKUDm9O95qWS2LJzwoVR01dITt")
if $result16.success {
    print "✓ Level 16 PASS"
} else {
    print $"✗ Level 16 FAIL: ($result16.message)"
}

print ""
print "All tests complete!"

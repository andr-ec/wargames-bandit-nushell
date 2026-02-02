#!/usr/bin/env nushell
# Test runner for levels 32-39

# Test level 32
print "Testing level 32..."
use levels/32/setup.nu
setup main setup | ignore
use levels/32/check.nu
let result32 = (check main check "GYokrn9Vb14NmhzO9BKjuV6OkwS4jGp8")
if $result32.success {
    print "✓ Level 32 PASS"
} else {
    print $"✗ Level 32 FAIL: ($result32.message)"
}

# Test level 33
print "Testing level 33..."
use levels/33/setup.nu
setup main setup | ignore
use levels/33/check.nu
let result33 = (check main check "yD1jt6XZ12n4ZFGk7tXhS4Q14PveE4G8")
if $result33.success {
    print "✓ Level 33 PASS"
} else {
    print $"✗ Level 33 FAIL: ($result33.message)"
}

# Test level 34
print "Testing level 34..."
use levels/34/setup.nu
setup main setup | ignore
use levels/34/check.nu
let result34 = (check main check "IfOzZF1tsMUZ1MUDmgNCykuY7UhGWw5T")
if $result34.success {
    print "✓ Level 34 PASS"
} else {
    print $"✗ Level 34 FAIL: ($result34.message)"
}

# Test level 35
print "Testing level 35..."
use levels/35/setup.nu
setup main setup | ignore
use levels/35/check.nu
let result35 = (check main check "D4s3J6b2S3JbD4pD.9r8Z4eVj2C4v8q")
if $result35.success {
    print "✓ Level 35 PASS"
} else {
    print $"✗ Level 35 FAIL: ($result35.message)"
}

# Test level 36
print "Testing level 36..."
use levels/36/setup.nu
setup main setup | ignore
use levels/36/check.nu
let result36 = (check main check "daV8r54i3Lf4z42SJvvuVvzxSTB6APIn")
if $result36.success {
    print "✓ Level 36 PASS"
} else {
    print $"✗ Level 36 FAIL: ($result36.message)"
}

# Test level 37
print "Testing level 37..."
use levels/37/setup.nu
setup main setup | ignore
use levels/37/check.nu
let result37 = (check main check "ALBUBUiqYsZd3tYGCAwVZNnR6cNkIgUh")
if $result37.success {
    print "✓ Level 37 PASS"
} else {
    print $"✗ Level 37 FAIL: ($result37.message)"
}

# Test level 38
print "Testing level 38..."
use levels/38/setup.nu
setup main setup | ignore
use levels/38/check.nu
let result38 = (check main check "4cwYehD9pQsWt9O6YUBaXUojUaYEfeZr")
if $result38.success {
    print "✓ Level 38 PASS"
} else {
    print $"✗ Level 38 FAIL: ($result38.message)"
}

# Test level 39
print "Testing level 39..."
use levels/39/setup.nu
setup main setup | ignore
use levels/39/check.nu
let result39 = (check main check "4cwYehD9pQsWt9O6YUBaXUojUaYEfeZr")
if $result39.success {
    print "✓ Level 39 PASS"
} else {
    print $"✗ Level 39 FAIL: ($result39.message)"
}

print ""
print "All tests complete!"

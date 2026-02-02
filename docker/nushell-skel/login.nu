# Welcome Banner for Bandit Wargame - Nushell Edition
print ""
print "══════════════════════════════════════════════════════════════════"
print "  Bandit Wargame - Nushell Edition"
print "══════════════════════════════════════════════════════════════════"
print ""

print $"(ansi cyan_bold)Level ($env.BANDIT_LEVEL)(ansi reset)"
print ""

print $"(ansi yellow)Goal:(ansi reset)"
open $"/etc/bandit_goal/bandit($env.BANDIT_LEVEL)" | print
print ""

print $"(ansi yellow)Useful commands for this level:(ansi reset)"
print $"  ($env.BANDIT_COMMANDS)"
print ""

print $"(ansi yellow)Getting help:(ansi reset)"
print "  help <command>     - Show help for a command"
print "  <command> --help   - Alternative help syntax"
print "  goal               - Show this level's goal again"
print ""

# Bandit Wargame Environment - Default Template
# This will be overwritten per-user during installation

$env.BANDIT_LEVEL = 0
$env.BANDIT_USER = "bandit0"
$env.BANDIT_COMMANDS = "ls, cd, open"
$env.PROMPT_COMMAND = { || "bandit0:~> " }
$env.PROMPT_INDICATOR = ""

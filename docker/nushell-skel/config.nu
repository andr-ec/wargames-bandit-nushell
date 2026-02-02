# Bandit Wargame Nushell Config

$env.config = {
    show_banner: false
    shell_integration: {
        osc2: false
        osc7: false
        osc8: false
        osc9_9: false
        osc133: false
        osc633: false
        reset_application_mode: false
    }
}

# Goal command - show level objective
def goal [] {
    open $"/etc/bandit_goal/bandit($env.BANDIT_LEVEL)"
}

# Source login banner
source ~/.config/nushell/login.nu

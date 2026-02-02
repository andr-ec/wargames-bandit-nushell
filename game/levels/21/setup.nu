#!/usr/bin/env nu
# Level 21 setup
# Create cron job and temporary file mechanism

export def "main setup" [] {
    let cron_config = "/etc/cron.d/cronjob_bandit22"
    let script_path = "/usr/bin/cronjob_bandit22.sh"

    # Create cron configuration
    "@reboot bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null" | save -f $cron_config

    # Add the scheduled job
    "* * * * * bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null" | append $cron_config

    # Generate placeholder password for bandit22
    let password = "bandit21"

    # Create the script template
    let script_template = """#!/bin/bash

tmp_file=__PLACEHOLDER__

chmod 644 /tmp/$tmp_file
cat /etc/bandit_pass/bandit22 > /tmp/$tmp_file
"""

    # Replace placeholder and save script
    $script_template | str replace "__PLACEHOLDER__" $password | save -f $script_path

    # Set permissions
    chmod 750 $script_path

    echo $"Created level 21 with password: bandit21"

    { success: true, message: $"Level 21 setup complete" }
}

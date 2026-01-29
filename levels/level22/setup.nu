#!/usr/bin/env nu
# Level 22 setup
# Create cron job and MD5-based password storage

export def "main setup" [] {
    let cron_config = "/etc/cron.d/cronjob_bandit23"
    let script_path = "/usr/bin/cronjob_bandit23.sh"

    # Create cron configuration
    "@reboot bandit23 /usr/bin/cronjob_bandit23.sh &> /dev/null" | save -f $cron_config

    # Add the scheduled job
    "* * * * * bandit23 /usr/bin/cronjob_bandit23.sh &> /dev/null" | append $cron_config

    # Copy existing script
    cp scripts/23_tmp_file2.sh $script_path

    # Set permissions
    chmod 750 $script_path

    echo $"Created level 22 with password: bandit22"

    { success: true, message: $"Level 22 setup complete" }
}

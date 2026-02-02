#!/usr/bin/env nu
# Level 24 setup
# Create cron job and script launcher for user directory

export def "main setup" [] {
    let cron_config = "/etc/cron.d/cronjob_bandit25"
    let script_path = "/usr/bin/cronjob_bandit24.sh"

    # Create cron configuration
    "@reboot bandit25 /usr/bin/cronjob_bandit24.sh &> /dev/null" | save -f $cron_config

    # Add the scheduled job
    "* * * * * bandit25 /usr/bin/cronjob_bandit24.sh &> /dev/null" | append $cron_config

    # Create directory
    mkdir "/var/spool/bandit25/foo"
    chmod 777 "/var/spool/bandit25/foo"

    # Copy existing script
    cp scripts/24_script_launcher.sh $script_path

    # Set permissions
    chmod 750 $script_path

    echo $"Created level 24 with password: bandit24"

    { success: true, message: $"Level 24 setup complete" }
}

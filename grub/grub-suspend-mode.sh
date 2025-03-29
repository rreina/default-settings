#!/bin/bash

GRUB_CONFIG="/etc/default/grub"
SUSPEND_MODE="mem_sleep_default=s2idle" # Needed for Apple computers not to die when the system suspends

# Check if the system is Apple or not, and set the suspend mode accordingly
set_suspend_mode() {
    if ! grep -q "^Apple" /sys/class/dmi/id/sys_vendor; then
        SUSPEND_MODE="mem_sleep_default=deep"  # Default system suspension for non-Apple systems
    fi
}

create_config() {
    cat <<EOF > "$GRUB_CONFIG"
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash $SUSPEND_MODE"
GRUB_TIMEOUT=0
GRUB_TIMEOUT_STYLE=hidden
GRUB_HIDDEN_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT_QUIET=true
GRUB_RECORDFAIL_TIMEOUT=0
EOF
    logger -t grub-suspend-mode "Created new GRUB configuration with suspend mode '$SUSPEND_MODE'"
}

set_suspend_mode
create_config

update-grub
logger -t grub-suspend-mode "Updated GRUB configuration"

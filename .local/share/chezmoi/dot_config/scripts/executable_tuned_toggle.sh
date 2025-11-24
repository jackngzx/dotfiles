#!/bin/bash

# Define the profiles to cycle through
PROFILES=("balanced-battery" "powersave")

# Get the current active profile (strip "Current active profile: ")
CURRENT_PROFILE=$(tuned-adm active | sed 's/Current active profile: //')

# Find the index of the current profile
CURRENT_INDEX=-1
for i in "${!PROFILES[@]}"; do
  if [[ "${PROFILES[$i]}" == "$CURRENT_PROFILE" ]]; then
    CURRENT_INDEX=$i
    break
  fi
done

# Calculate the index of the next profile
# If not found, start at balanced (index 0). Otherwise, move to the next, wrapping around.
if [ $CURRENT_INDEX -eq -1 ]; then
  NEXT_INDEX=0
else
  NEXT_INDEX=$(((CURRENT_INDEX + 1) % ${#PROFILES[@]}))
fi

# Get the next profile name
NEXT_PROFILE="${PROFILES[$NEXT_INDEX]}"

# Switch the profile using tuned-adm
# **NOTE**: This command requires root/sudo privileges or for your user to be configured to run it without a password.
# The `pkexec` command is generally safer for graphical environments to prompt for a password.
# If you are in a system where you can use `sudo` without a password, you can replace `pkexec tuned-adm...`
# with `sudo tuned-adm...` or configure `pkexec` for better integration.

pkexec tuned-adm profile $NEXT_PROFILE

# You can optionally send a notification to confirm the change
notify-send -a "Waybar Tuned" "Profile Switched" "Tuned profile set to: $NEXT_PROFILE"

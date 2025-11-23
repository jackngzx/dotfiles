#!/bin/bash

# A simple script to use fuzzel as a calculator interface.
# Dependencies: fuzzel, bc, notify-send
# You might need 'bc' for floating point math and 'notify-send' for the output notification.

# --- Configuration ---
# Set the desired precision (number of decimal places)
PRECISION=4
# Prompt text for fuzzel
FUZZEL_PROMPT="Calc: "
# Fuzzel dmenu-mode options (customize as needed)
FUZZEL_OPTS="--dmenu --lines=0 --prompt \"$FUZZEL_PROMPT\""

# Use fuzzel in dmenu mode to get input from the user.
# The `--lines=0` and piping empty input (`echo ""`) ensures only the prompt/input box appears.
# The `--dmenu` flag makes fuzzel act like dmenu, printing the final input to stdout.
INPUT=$(echo "" | fuzzel $FUZZEL_OPTS)

# Check if the user entered anything
if [ -z "$INPUT" ]; then
  exit 0
fi

# Clean up the input string:
# 1. Remove the prompt (optional, but cleaner)
# 2. Replace the multiplication symbol 'x' (if used by the user) with '*' for bc
CALC_EXPRESSION=$(echo "$INPUT" | sed "s/^$FUZZEL_PROMPT//g" | sed 's/x/*/g')

# Use 'bc' to calculate the result
# 'scale' sets the decimal precision.
# 'l' enables the math library for functions like sin(), cos(), log(), sqrt() if needed.
# The calculation is piped into bc.
RESULT=$(echo "scale=$PRECISION; $CALC_EXPRESSION" | bc -l 2>/dev/null)

# Check if the result is empty (bc error or no valid calculation)
if [ -z "$RESULT" ]; then
  # Use 'bc' to check for a syntax error and provide a better error message if possible
  ERROR_CHECK=$(echo "scale=$PRECISION; $CALC_EXPRESSION" | bc -l 2>&1 >/dev/null)

  if [[ "$ERROR_CHECK" == *"syntax error"* ]]; then
    notify-send "Fuzzel Calculator Error" "Invalid calculation: $CALC_EXPRESSION" -i error
  else
    notify-send "Fuzzel Calculator Error" "Could not compute: $CALC_EXPRESSION" -i error
  fi
  exit 1
fi

# --- Output the result ---

# 1. Copy the result to the clipboard (recommended for quick pasting)
#    - Requires `wl-copy` or similar Wayland clipboard tool (e.g., from wl-clipboard package)
echo -n "$RESULT" | wl-copy

# 2. Send a notification with the result
notify-send "Calculator Result" "Input: $CALC_EXPRESSION\nResult: **$RESULT** (Copied to clipboard)" -i info

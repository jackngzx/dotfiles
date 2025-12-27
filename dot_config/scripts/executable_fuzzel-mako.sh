#!/bin/bash

# Use makoctl history to get notification details in a machine-readable format.
# We parse the output to show the summary and content in fuzzel.

# The format of each line from makoctl history is:
# <id> <app-name> <summary> <content>

history_output=$(makoctl history)

if [ -z "$history_output" ]; then
  notify-send "Mako History" "History is empty."
  exit 0
fi

# Process the history output for fuzzel.
# We display "summary: content" in fuzzel and keep the notification ID accessible.
# The 'echo' within the while loop ensures that only the display text goes to fuzzel,
# while the 'id' is used later in the script.
selected_line=$(echo "$history_output" | awk '{ 
    # Store the first field (the ID) and remove it from the line for display
    id = $1; 
    # Reconstruct the rest of the line (summary and content)
    display_text = substr($0, length($1) + 2); 
    # Print the display text for fuzzel, and ensure we can link it back to the ID
    print display_text
}' | fuzzel --dmenu --prompt="Notification History:")

# Check if a selection was made
if [ -n "$selected_line" ]; then
  # Find the corresponding ID from the original history output
  # We use 'grep' to find the line where the rest of the content matches the selected line
  # Note: This approach might have issues with identical notification contents.
  # A more robust script might use a temporary file with a clear delimiter.

  # A simpler but less robust approach:
  # We find the ID by extracting it from the original history output based on the selected content
  selected_id=$(echo "$history_output" | grep -F "$selected_line" | awk '{print $1}' | head -n 1)

  if [ -n "$selected_id" ]; then
    # Restore the selected notification from history
    makoctl restore -n "$selected_id"
  fi
fi

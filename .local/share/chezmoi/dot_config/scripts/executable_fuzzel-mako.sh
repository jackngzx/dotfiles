#!/bin/sh

# Get notification history as JSON, format it, and pipe to fuzzel
makoctl history | jq -r '.data[] | "\(.app_name.data): \(.summary.data) - \(.body.data) (ID: \(.id.data))"' | fuzzel --dmenu -p "Notification History: "

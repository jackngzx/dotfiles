#!/bin/sh

if pgrep -x "fuzzel" >/dev/null; then
  # Fuzzel is running, so kill it (close it)
  pkill fuzzel
else
  # Fuzzel is not running, so launch it
  fuzzel
fi

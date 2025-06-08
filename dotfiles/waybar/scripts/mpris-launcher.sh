#!/bin/bash

player=$1

# Map known MPRIS names to window classes and launch commands
case "$player" in
  spotify)
    app_class="Spotify"
    app_exec="spotify"
    ;;
  vlc)
    app_class="vlc"
    app_exec="vlc"
    ;;
  mpv)
    app_class="mpv"
    app_exec="mpv"
    ;;
  chromium)
    app_class="Chromium"
    app_exec="chromium"
    ;;
  firefox)
    app_class="firefox"
    app_exec="firefox"
    ;;
  mopidy)
    app_class="Mopidy"
    app_exec="mopidy"
    ;;
  *)
    app_class="$player"
    app_exec="$player"
    ;;
esac

# Look for a window with this app class
client_address=$(hyprctl clients -j | jq -r \
  --arg class "$app_class" '.[] | select(.class == $class) | .address' | head -n 1)

if [ -n "$client_address" ]; then
  # Focus the window
  hyprctl dispatch focuswindow address:$client_address
else
  # Launch the app
  setsid $app_exec >/dev/null 2>&1 &
fi

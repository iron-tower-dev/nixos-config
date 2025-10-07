#!/usr/bin/env bash
# Set wallpaper using swww
# This script will be populated with the correct path by home-manager

# Wait for swww daemon to be ready
sleep 1

# Set wallpaper - path will be set by Nix
WALLPAPER="@WALLPAPER_PATH@"

if [ -f "$WALLPAPER" ]; then
    swww img "$WALLPAPER" --transition-type fade --transition-duration 2
else
    echo "Wallpaper not found: $WALLPAPER"
fi

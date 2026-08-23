#!/bin/bash

pkill waybar
pkill hyprpaper
pkill hypridle

waybar &
hyprpaper &
hypridle &

#!/bin/bash

sudo rm -rf /usr/share/themes/gtk-theme
sudo cp -r ~/.config/gtk-theme /usr/share/themes

sudo rm -rf /usr/share/icons/gtk-icons
sudo cp -r ~/.config/gtk-icons /usr/share/icons
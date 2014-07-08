#!/bin/sh
# This is so ugly that I do not even put here a license.
# Or my name.

cd vapis
vapigen --pkg gio-2.0 --library UPowerGlib-1.0 /usr/share/gir-1.0/UPowerGlib-1.0.gir

mv UPowerGlib-1.0.vapi upower-glib.vapi
sed 's/UPowerGlib-1.0.h/upower.h/g' -i upower-glib.vapi

#!/usr/bin/ruby
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

require_relative 'helper'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

panel_height = 24
monitor = get_monitor(ARGV)

# do `man herbsluftclient`, and type \pad to search what it means
system("herbstclient pad #{monitor} #{panel_height} 0 #{panel_height} 0")

lemon_parameters = get_lemon_parameters(monitor, panel_height)
puts(lemon_parameters)
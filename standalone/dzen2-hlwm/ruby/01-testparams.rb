#!/usr/bin/ruby
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

require_relative 'helper'
require_relative 'pipehandler'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

panel_height = 24
monitor = get_monitor(ARGV)

# do `man herbsluftclient`, and type \pad to search what it means
system("herbstclient pad #{monitor} #{panel_height} 0 #{panel_height} 0")

dzen2_parameters = get_dzen2_parameters(monitor, panel_height)
puts(dzen2_parameters)
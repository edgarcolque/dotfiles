#!/usr/bin/php 
<?php # using PHP7
# This is a modularized config for herbstluftwm tags in lemonbar

require_once(__DIR__.'/helper.php');
require_once(__DIR__.'/pipehandler.php');

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

$panel_height = 24;
$monitor = get_monitor($argv);

// do `man herbsluftclient`, and type \pad to search what it means
system("herbstclient pad $monitor $panel_height 0 $panel_height 0");

$lemon_parameters = get_lemon_parameters($monitor, $panel_height);

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

// remove all lemonbar instance
system('pkill lemonbar');

// run process in the background
detach_lemon($monitor, $lemon_parameters);

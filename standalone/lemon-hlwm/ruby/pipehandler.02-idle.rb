require_relative 'output'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

def handle_command_event(monitor, event) 
  # find out event origin
  column = event.split("\t")
  origin = column[0]
    
  tag_cmds = ['tag_changed', 'tag_flags', 'tag_added', 'tag_removed']
  title_cmds = ['window_title_changed', 'focus_changed']

  case origin
  when 'reload'
    os.system('pkill lemonbar')
  when 'quit_panel'
    exit
  when *tag_cmds       # splat operator
    set_tag_value(monitor)
  when *title_cmds     # splat operator
    title = column.length > 2 ? column[2] : ''
    set_windowtitle(title)
  end
end

def content_init(monitor, lemon_stdin)
  # initialize statusbar before loop
  set_tag_value(monitor)
  set_windowtitle('')
      
  text = get_statusbar_text(monitor)
  lemon_stdin.puts(text)
end

def content_walk(monitor, lemon_stdin)
  # start an io
  command_in = 'herbstclient --idle'
  
  IO.popen(command_in, "r") do |io_idle|
    while io_idle do 
      # read next event, trim newline
      event = (io_idle.gets).strip
      handle_command_event(monitor, event)
        
      text = get_statusbar_text(monitor)
      lemon_stdin.puts(text)
    end
    io_idle.close()
  end
end

def run_lemon(monitor, parameters)
  command_out  = 'lemonbar ' + parameters

  IO.popen(command_out, 'w') do |io_lemon| 
  
    content_init(monitor, io_lemon)
    content_walk(monitor, io_lemon) # loop for each event
        
    io_lemon.close()
  end
end

def detach_lemon(monitor, parameters)
  # warning: Signal.trap is application wide
  Signal.trap("PIPE", "EXIT")
    
  pid_lemon = fork { run_lemon(monitor, parameters) }
  Process.detach(pid_lemon)
end

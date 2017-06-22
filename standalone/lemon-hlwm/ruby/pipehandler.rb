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
    set_windowtitle(column[2])
  end
end

def init_content(monitor, stdin)
  # initialize statusbar before loop
  set_tag_value(monitor)
  set_windowtitle('')
      
  text = get_statusbar_text(monitor)
  stdin.puts(text)
end

def walk_content(monitor, stdin)    
  # start a pipe
  command_in = 'herbstclient --idle'
  
  IO.popen(command_in, "r") do |f|     
    while f do 
      # read next event
      event = f.gets
      handle_command_event(monitor, event)
        
      text = get_statusbar_text(monitor)
      stdin.puts(text)
    end
    f.close()    
  end
end

def run_lemon(monitor, parameters)
  command_out  = 'lemonbar ' + parameters

  IO.popen(command_out, 'w') do |f| 
  
    init_content(monitor, f)
    walk_content(monitor, f) # loop for each event
        
    f.close()    
  end
end

def detach_lemon(monitor, parameters)
  # warning: Signal.trap is application wide
  Signal.trap("PIPE", "EXIT")
    
  pid = fork { run_lemon(monitor, parameters) }
  Process.detach(pid)
end

# run with:  god -c /path/to/this_file.god
# 
# This is the actual config file used to keep the thin thinning along for XXX.rb
# these ports are defined in config.yml

SINATRA_ROOT = "/home/rails/apps/facemask"
PORT_NUM = 45666

[PORT_NUM].each do |port|
  God.watch do |w|
    w.name = "facemask-thin-#{port}"
    w.interval = 30.seconds # default    
    w.start = "thin -C #{SINATRA_ROOT}/config.yml start"  
    w.stop = "thin -C #{SINATRA_ROOT}/config.yml stop"  
    w.restart = "thin -C #{SINATRA_ROOT}/config.yml restart"  
    w.start_grace = 10.seconds
    w.restart_grace = 10.seconds
    w.pid_file = File.join(SINATRA_ROOT, "thin.#{port}.pid")
    
    w.behavior(:clean_pid_file)
    
    # Checks if process is running every 5 seconds
    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 5.seconds
        c.running = false
      end
    end
        
  end
end
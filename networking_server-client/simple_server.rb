require 'socket'

server = TCPServer.new 2000 # Server bound to port 2000

loop do
  client = server.accept    # Wait for a client to connect
  
  puts "client connected"
  
  client.puts "Hello !"
  client.puts "Time is #{Time.now}"
  client.close
  
  puts "client disconnected"
end
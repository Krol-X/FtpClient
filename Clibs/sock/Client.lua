require "Sock"
sock = Sock:new()
if arg then
  host = arg[1] or "127.0.0.1"
  port = arg[2] or "8080"
end
print("Attempting connection to host '" ..host.. "' and port " ..port.. "...")
if sock:connect(host, port) then
  print("Connected! Please type stuff (empty line to stop):")
  repeat
    s = io.read("*l")
    x = sock:send(s..'\n')
  until not s or s=="" or x == 0
  sock:disconnect()
else
  print("Couldn't connect!")
end
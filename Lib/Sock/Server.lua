require "Sock"
sock = Sock:new()
if arg then
  host = arg[1] or "127.0.0.1"
  port = arg[2] or "8080"
end
io.write("Binding to host '" ..host.. "' and port " ..port.. "... ")
if sock:bind(host, port) then
  print("OK")
  repeat
    client = sock:accept()
  until client
  print("Connected. Here is the stuff:")
  repeat
    data, err = client:receive('s')
    if not err then
      print(data)
    end
  until err
else
  print("FAIL")
end
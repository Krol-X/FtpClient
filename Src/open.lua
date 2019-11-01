return {
  help = [=[Make connection with host: OPEN [ip] [port]]=];
  main = function(args)
    args = args or ""
    local host, port = args:trimspaces():match("(.+)%s+(%d+)$")
    if not host and args ~= "" then host = args end
    host, port = host or "", port or ""
    if host == "" then host = io.sread("HOST = ") end
    if not tonumber(port) then port = io.nread("PORT = ") end
    local x = control:connect(host, port)
    printclb(x, nil, {"Connected succeful!", "Connection error!"})
    control:send("TYPE I")
    if x then answer.print(control:receive()) end
  end;
}
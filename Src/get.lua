return {
  help = [["get <file>" or "down <file>" - download file]];
  main = function(args)
    local path, name, ext = string.splitpath(args)
    ext = ext or ""
    ext = ext ~= "" and '.'..ext or ext
    if control:connected() then
      pasv()
      print("Downloading file...")
      control:sendln("retr "..args)
      if not data:connect() then Error_dcon() f:close() return end
      local x = data:receive('a')
      local y = answer.highcode(answer.print(control:receive()))
      if y < 3 then
        local f = assert(io.open(name..ext, "wb"))
        f:write(x)
        f:close()
        print(table.concat{"Received ", #x, ' bytes of "', name, ext, '"'})
      end
      answer.print(control:receive())
      data:disconnect()
    else
      Error_con()
    end
  end;
}

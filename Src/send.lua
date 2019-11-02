return {
  help = [["send <name>" or "up <name>" - upload file to server]];
  main = function(args)
    local path, name, ext = string.splitpath(args)
    ext = ext or ""
    ext = ext ~= "" and '.'..ext or ext
    local f = io.open(args, "rb")
    if not f then Error_file(args) return end
    if control:connected() then
      pasv()
      io.setattr(color.inter)
      print("Uploading file...")
      control:sendln("stor "..name..ext)
      if not data:connect() then Error_dcon() f:close() return end
      local x = f:read('*a')
      y = data:send(x)
      print(table.concat{"Transfered ", y, ' bytes of "', name, ext, '" with size', #x})
      f:close()
      answer.print(control:receive())
      data:disconnect()
    else
      Error_con()
    end
  end;
}

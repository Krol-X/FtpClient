local nohelp = "Sorry, help for this command is not available in this version!"

help = {
  __help = function(s)
    local start = (s == help)
    if not s or start then
      print([[Simple Ftp-Client by _KROL]])
      if start then return end
      print("Availble commands:")
      local x = {}
      for k, _ in pairs(help) do
        if k:sub(1, 2) ~= "__" then
          if #x > 4 then
            print(table.unpack(x))
            x = {}
          end
          table.insert(x, k)
        end
      end
      if #x > 0 then print(table.unpack(x)) end
    else
      s = s:lower()
      if help[s] then
        print(help[s])
      else
        Error_cmd(s)
      end
    end
  end;
  ["!"] = nohelp;
  cd = nohelp;
  cls = nohelp;
  close = [[Close connection]];
  del = nohelp;
  dir = nohelp;
  get = nohelp;
  help = [[Type "HELP <command>" or "? <command>" for specific command help ...]];
  send = nohelp;
  status = nohelp;
  md = nohelp;
  open = [=[Make connection with host: OPEN [ip] [port]]=];
  user = [=[Login to host: USER [username] [password]]=];
  quit = [[Close connection and exit to OS]];
}
-- ѕсевдонимы команд
help["?"] = help.help
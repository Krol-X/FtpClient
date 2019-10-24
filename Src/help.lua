local nohelp = "Sorry, help for this command is not available in this version!"

help = {
  __help = function(s)
    local start = not s
    if start or s == "" then
      print("Ftp-Client by _KROL")
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
  close = nohelp;
  del = nohelp;
  dir = nohelp;
  get = nohelp;
  help = [[Type "HELP <command>" or "? <command>" for specific command help ...]];
  send = nohelp;
  status = nohelp;
  md = nohelp;
  open = nohelp;
  user = nohelp;
  quit = nohelp;
}
-- ѕсевдонимы команд
help["?"] = help.help
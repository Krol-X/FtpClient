local list, cols = {}, 1
return {
  help = [[Type "HELP <command>" or "? <command>" for specific command help]];
  init = function(args)
    args = args or command
    for k, v in pairs(args) do
      table.insert(list, k)
    end
    table.insert(list, '?')
    table.insert(list, '!')
    table.sort(list, function(a, b) return a<b end)
    cols = config.help.colons
    if type(cols) ~= "number" or cols < 1 then
      config.help.colons = stdconfig.help.colons
      cols = config.help.colons
    end
  end;
  main = function(args)
    io.setattr(color.inter)
    if args then
      if command[args] then
        print(command[args].help)
      else
        Error_cmd() -- ?
      end
    else
      print("Available commands:")
      local function f(s)
        return s..string.rep(' ', 16-math.fmod(#s, 16))
      end
      local rows, sz = math.divide(#list, cols) + 1, #list
      for i=0, rows*cols-1 do
        local x, y = math.divide(i, cols)
        x = y*rows+x+1
        if x <= sz then
          io.write(f( list[x] ))
        else
          io.write(string.rep(' ', 16))
        end
        if y == cols-1 then print() end
      end
      print()
    end
  end;
}
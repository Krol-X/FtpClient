local list, cols, width = {}, 1, width
local shrink = {['~'] = "raw", ['?'] = "help", ['!'] = "exec"}
return {
  help = [["help <command>" or "?<command>" - specific command help]];
  init = function(args)
    args = args or command
    for k, v in pairs(args) do
      table.insert(list, k)
    end
    table.insert(list, '~')
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
      args = shrink[args] or args
      if command[args] then
        print(command[args].help)
      else
        Error_cmd(args)
      end
    else
      print("Available commands:")
      width = config.help.width
      if type(width) ~= "number" or width < 1 then
        config.help.width = stdconfig.help.width
        width = config.help.width
      end
      local function f(s)
        return s..string.rep(' ', width-math.fmod(#s, width))
      end
      local rows, sz = math.divide(#list, cols) + 1, #list
      for i=0, rows*cols-1 do
        local x, y = math.divide(i, cols)
        x = y*rows+x+1
        if x <= sz then
          io.write(f( list[x] ))
        else
          io.write(string.rep(' ', width))
        end
        if y == cols-1 then print() end
      end
      print()
    end
  end;
}
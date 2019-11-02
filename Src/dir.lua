return {
  help = [["dir [name]" or "ls [name]" - print directory contents]];
  main = function(args)
    args = args or ""
    if control:connected() then
      pasv()
      control:sendln("list "..args)
      if not data:connect() then Error_dcon() return end
      local x = data:receive()
      local y = answer.highcode(answer.print(control:receive()))
      if y < 3 then
        for _, v in ipairs(x) do print(v) end
      end
      data:disconnect()
    else
      Error_con()
    end
  end;
}

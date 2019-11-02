return {
  help = [["ren [from] [to]" - rename file]];
  main = function(args)
    if control:connected() then
      args = args or ""
      local from, to = args:trimspaces():match("(.+)%s+(.+)$")
      if not from and args ~= "" then from = args end
      from, to = from or "", to or ""
      io.setattr(color.inter)
      if from == "" then from = io.sread("FROM: ") end
      if to   == "" then to   = io.sread("TO: ") end
      io.setattr(color.ok)
      control:sendln("rnfr "..from)
      control:sendln("rnto "..to)
      answer.print(control:receive())
    else
      Error_con()
    end
  end;
}
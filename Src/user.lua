return {
  help = [["user [username]" - login to server]];
  main = function(args)
    if control:connected() then
      io.setattr(color.inter)
      args = args or io.sread("USER: ")
      control:sendln("user "..args)
      local r = control:receive()
      t = answer.print(r)
      if t == 331 then
        io.write("PASS: ")
        r = io.readpass()
        control:sendln("pass "..r)
        t = answer.print(control:receive())
      end
      if answer.highcode(t) < 4 then
        control:sendln("TYPE I")
        answer.print(control:receive())
      end
    else
      Error_con()
    end
  end;
}
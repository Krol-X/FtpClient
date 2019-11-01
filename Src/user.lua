return {
  help = [=[Login to host: USER [username]]=];
  main = function(args)
    if control:connected() then
      args = args or io.sread("USER: ")
      control:sendln("user "..args)
      local r = control:receive()
      t = answer.print(r)
      if t == 331 then
        r = io.readpass("PASS: ")
        control:sendln("pass "..r)
        local r = control:receive()
        answer.print(r)
      end
    else
      Error_con() -- ???
    end
  end;
}
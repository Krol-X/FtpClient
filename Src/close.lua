return {
  help = [[Close connection with server]];
  main = function(args)
    if control:connected() then
      if not args then
        control:sendln("quit")
        answer.print(control:receive())
      end
      data:disconnect()
      control:disconnect()
    else
      if not args then Error_con() end -- ???
    end
  end;
}
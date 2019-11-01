return {
  help = [[del <name> - delete file/directory]];
  main = function(args)
    if control:connected() then
        control:sendln("dele "..topath(s))
        answer.print(control:receive())
    else
        Error_con() -- ???
    end
  end;
}
return {
  help = [[cd <name> - change directory]];
  main = function(args)
    if control:connected() then
        control:sendln("cwd "..topath(s))
        answer.print(control:receive())
    else
        Error_con() -- ???
    end
  end;
}
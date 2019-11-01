return {
  help = [[md <name> - make directory]];
  main = function(args)
    if control:connected() then
        control:sendln("mkd "..topath(s))
        answer.print(control:receive())
    else
        Error_con() -- ???
    end
  end;
}
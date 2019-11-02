return {
  help = [["md <name>" or "mkdir <name>" - make directory]];
  main = function(args)
    if control:connected() then
        control:sendln("mkd "..s)
        answer.print(control:receive())
    else
        Error_con()
    end
  end;
}
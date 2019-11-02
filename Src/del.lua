return {
  help = [["del <name>" or "rm <name>" - delete file/directory]];
  main = function(args)
    if control:connected() then
        control:sendln("dele "..s)
        answer.print(control:receive())
    else
        Error_con()
    end
  end;
}
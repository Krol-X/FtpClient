return {
  help = [["cd <name>" or "chdir <name>" - change directory]];
  main = function(args)
    if control:connected() then
      control:sendln("cwd "..s)
      answer.print(control:receive())
    else
      Error_con()
    end
  end;
}
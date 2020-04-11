return {
  help = [["rd <name>" - delete directory]];
  main = function(args)
    if control:connected() then
      control:sendln("rmd "..s)
      answer.print(control:receive())
    else
      Error_con()
    end
  end;
}
return {
  help = [["raw <...>" or "~<...>" - send raw-command to server]];
  main = function(args)
    if control:connected() then
      control:sendln(args)
      answer.print(control:receive())
    else
      Error_con()
    end
  end;
}
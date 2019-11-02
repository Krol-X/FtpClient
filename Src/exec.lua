return {
  help = [["!<...>" or "exec <...>" - execute host OS command]];
  main = function(args)
    os.execute(args)
    print()
  end;
}
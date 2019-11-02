return {
  help = [["exec <...>" or "!<...>" - execute host OS command]];
  main = function(args)
    os.execute(args)
    print()
  end;
}
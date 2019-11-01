return {
  help = [[Execute host OS command]];
  main = function(args)
    os.execute(args)
  end;
}
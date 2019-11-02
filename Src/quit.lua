return {
  help = [["quit" or "exit" - close connection and return to OS]];
  main = function(args)
    command["close"].main(true)
    stat.quit = true
  end;
}
return {
  help = [["status" - print client status]];
  main = function()
    print("Connected: "..tostring(control:connected()))
    print("Type: "..stat.type)
  end;
}
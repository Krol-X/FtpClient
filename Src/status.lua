return {
  help = [[Print client status]];
  main = function()
    print("Connected: "..tostring(control:connected()))
    print("Type: "..stat.type)
  end;
}
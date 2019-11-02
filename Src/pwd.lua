return {
  help = [["pwd" - print current directory]];
  main = function()
    if control:connected() then
        control:sendln("pwd ")
        answer.print(control:receive())
    else
        Error_con()
    end
  end
}
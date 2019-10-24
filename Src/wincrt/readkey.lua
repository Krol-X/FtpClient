require "wincrt"

x = false
repeat
  key = wincrt.readkey()
  print(key, string.char(key%256))
  b = (key == 27)
  if b then
    b = x
    x = true
  else
    x = false
  end
until x and b
require "wincrt"
for j = 0, 15 do
  for i = 0, 15 do
    wincrt.setattr(j*16+i)
    io.write('*')
  end
  print()
end
wincrt.setattr(0x07)
print(wincrt.getxy())
io.read("*l")
wincrt.clrscr()
wincrt.gotoxy(0, 0)
io.read("*l")

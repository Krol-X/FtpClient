local wincrt = require "wincrt"

io.readkey = wincrt.readkey
io.getxy   = wincrt.getxy
io.gotoxy  = wincrt.gotoxy
io.getattr = wincrt.getattr
io.setattr = wincrt.setattr
io.clrscr  = function(attr)
  if attr then io.setattr(attr) end
  wincrt.clrscr()
  wincrt.gotoxy(0, 0)
end
io.readpass = io_compatibility and
  function() return io.read("*l") end or
  function()
    local key
    repeat
      key = io.readkey()%256
      if key >= 32 then
        s = s..string.char(key)
      elseif key == 8 and #s > 0 then
        s = s:sub(1, #s-1)
      end
    until key == 13
    print()
    return s
  end


function printcl(cl, s) setattr_(cl) print(s) end
function printclb(b, cl, s)
  b  = b and 1 or 2
  cl = type(cl)=="table" and (#cl==2 and cl or {cl[1], cl[1]})
       or type(cl)=="number" and {cl, cl}
       or {color.ok, color.err}
  s  = type(s)=="table" and (#s==2 and s or {s[1], s[1]})
       or type(s)=="string" and {s, s}
       or {tostring(s), tostring(s)}
  io.setattr(cl[b])
  print(s[b])
end


function Error(s) io.setattr(0x0C) print("Error: "..s) end

require "wincrt"

-- Выбор реализаций функций ввода-вывода для разного окружения
readkey_ = wincrt.readkey
getattr_ = wincrt.getattr
setattr_ = wincrt.setattr

clnorm  = 0x0F
clpre   = 0x09
clok    = 0x0A
clinter = 0x0E
clerr   = 0x0C


clrscr_ = function()
  wincrt.clrscr()
  wincrt.gotoxy(0, 0)
end


read_ =
--[ Common variant
function(s)
  if s then
    local x
    repeat
      io.write(s)
      x = read_()
    until #x>0
    return x
  else
    io.flush()
    return io.read('*l')
  end
end
--]]


readn_ =
--[ Common variant
function(s)
  if s then
    local i, x
    repeat
      io.write(s)
      i, x = pcall(readn_)
      if not x then io.read('*a') end
    until i
    return x
  else
    io.flush()
    return io.read('*n')
  end
end
--]]


readpass_ =
--[[ Common non-protected variant
read_
--]]
--[[ Windows variant ?
echo.|set /p="Password: "
--]]
--[ Console variant
function(s)
  io.write(s); s = ""
  local key, x, y
  repeat
    key = readkey_()%256
    if key >= 32 then
      s = s..string.char(key)
    elseif key == 8 and #s > 0 then
      s = s:sub(1, #s-1)
    end
  until key == 13
  print()
  return s
end
--]]

function prints(t) t = t or {}; for i=1, #t do print(t[i]) end end
function printcl(cl, s) setattr_(cl) print(s) end
function printclb(b, cl, s)
  b  = b and 1 or 2
  cl = type(cl)=="table" and (#cl==2 and cl or {cl[1], cl[1]})
       or type(cl)=="number" and {cl, cl}
       or {clok, clerr}
  s  = type(s)=="table" and (#s==2 and s or {s[1], s[1]})
       or type(s)=="string" and {s, s}
       or {tostring(s), tostring(s)}
  setattr_(cl[b])
  print(s[b])
end



-- Вывод ошибок
function Error(s) wincrt.setattr(0x0C) print("Error: "..s) end
function Error_cmd(s) Error('Unknown Command "'..s..'"') end
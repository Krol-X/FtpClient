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
--[ Common variant
function() return io.read('*l') end
--]]
--[[ Сonsole variant
function()
  local s = ""; local key, x, y
  repeat
    key = readkey()%256
    if key >= 32 then
      s = s + key
    elseif key == 8 and #s > 0 then
      s = s:sub(s, 1, #s-1)
    end
  until key = 13
  return s
end
--]]

-- Вывод ошибок
function Error(s) wincrt.setattr(0x0C) print("Error: "..s) end
function Error_cmd(s) Error('Unknown Command "'..s..'"') end
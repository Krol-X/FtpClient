require "wincrt"

-- Выбор реализаций функций ввода-вывода для разного окружения
readkey_ = wincrt.readkey
getattr_ = wincrt.getattr
setattr_ = wincrt.setattr

clrscr_ = function()
  wincrt.clrscr()
  wincrt.gotoxy(0, 0)
end

read_ =
--[ Common variant
function() return io.read('*l') end
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
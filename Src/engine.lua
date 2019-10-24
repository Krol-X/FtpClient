--require "socket"
require "tools"

-- Состояние программы
local conn
stat = {
  conn = nil,
  host = nil,
  port = nil,
  quit = false,
  type = "I",
}

-- Вывод ошибок
function Error(s) wincrt.setattr(0x0C) print("Error: "..s) end
function Error_cmd(s) Error('Unknown Command "'..s..'"') end
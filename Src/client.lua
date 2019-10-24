-- Цель: ориентир на windows ftp.exe, но с возможностью самому вводить команды
--[[ TODO:
  1. Реализация основных команд
  2. Реализация остальных команд
  3. Реализация cmdline()
]]--
--require "socket"
require "tools"
require "wincrt"


-- Вывод ошибок
function Error(s) wincrt.setattr(0x0C) print("Error: "..s) end
function Error_cmd(s) Error('Unknown Command "'..s..'"') end

-- Состояние программы
local conn
stat = {
  conn = nil,
  host = nil,
  port = nil,
  quit = false,
  type = "I",
}


help = {

}


-- Основные команды
command = {
  ["!"] = function(s)
    os.execute(s)
  end;

--[[
  ascii = function()
    stat.type = "A"
    -- Сервер надо уведомлять?
  end;
--]]

  binary = function()
    stat.type = "I"
    -- Сервер надо уведомлять?
  end;

  cd = function(s)
    -- MAKEIT
  end;

  cls = function()
    wincrt.clrscr()
    wincrt.gotoxy(0, 0)
  end;

  del = function(s)
    -- MAKEIT
  end;

  dir = function(s)
    -- MAKEIT
  end;

  get = function(s)
    -- MAKEIT
  end;

  send = function(s)
    -- MAKEIT
  end;

  md = function(s)
    -- MAKEIT
  end;

  rd = function(s)
    -- MAKEIT
  end;

  open = function(s)
    -- MAKEIT
  end;

  close = function()
    -- MAKEIT
  end;

  user = function(s)
    -- MAKEIT
  end;

  status = function(s)
    print("Connected: "..(stat.conn and "true" or "false")..';', stat.conn and ("User: "..stat.user), "Type: "..stat.type)
  end;

  help = function(s)
    if s == "" or s == 0 then
      print("Ftp-Client by _KROL")
      if s == 0 then return end
      print("Availble commands:")
      local x = {}
      for k, _ in pairs(command) do
        if #x > 3 then
          print(table.unpack(x))
          x = {}
        end
        table.insert(x, k)
      end
      if #x > 0 then print(table.unpack(x)) end
    elseif command[s] then
      if help[s] then
        print(help[s])
      else
        print("Sorry, help for this command is not available in this version!")
      end
    else
      Error_cmd(s)
    end
  end;

  quit = function()
    stat.quit = true
  end;
}
-- Псевдонимы команд
command["?"]  = command.help;
command.chdir = command.cd;
command.exit  = command.quit;
command.ls    = command.dir;
command.mkdir = command.md;
command.rm    = command.del;
command.rmdir = command.rd;

-- Обработка значений командной строки
function cmdline()
  -- ...
end cmdline()


-- Основная часть программы
function main()
  if stat.host and stat.port then
    -- Попытка соединиться...
  end
  wincrt.old = wincrt.getattr()
  io.write("Welcome to ")
  command.help(0);
  repeat
    wincrt.setattr(0x0A)
    io.write("ftp> ");
    s = io.read("*l");
    wincrt.setattr(0x0F)
    if s then
      s = s:trimspaces()
      i, j = s:find("([^%s]+)")
      cmd = s:sub(i, j)
      if command[cmd] then
        command[cmd](s:sub(j+1):trimspaces())
      else
        Error_cmd(cmd)
      end
    else
      command.quit()
    end
  until stat.quit
  wincrt.setattr(wincrt.old)
end main()
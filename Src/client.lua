-- Цель: ориентир на windows ftp.exe, но с возможностью самому вводить команды
--[[ TODO:
  1. Реализация основных команд
  2. Реализация остальных команд
  3. Реализация cmdline()
]]--
require "engine"
require "conio"
require "help"

-- Основные команды
command = {
  open = function(s)
    -- MAKEIT
  end;

  close = function()
    -- MAKEIT
  end;

  user = function(s)
    io.write("USER: ");
    s = s or read_("*l")
    send("usr "..s)
    local r = receive()
    answer.print(r)
    if answer.ok(r) then
      io.write("PASS: ")
      r = readpass_()
      send("pass "..r)
      local r = receive()
      answer.print(r)
    end
  end;

  status = function(s)
    print("Connected: "..(stat.conn and "true" or "false")..';', "Type: "..stat.type)
  end;

--[[
  ascii = function()
    stat.type = "A"
    -- Сервер надо уведомлять?
  end;

  binary = function()
    stat.type = "I"
    -- Сервер надо уведомлять?
  end;
--]]

  dir = function(s)
    -- MAKEIT
  end;

  cd = function(s)
    send("cwd "..topath(s))
    answer.print(receive())
  end;

  md = function(s)
    send("mkd "..topath(s))
    answer.print(receive())
  end;

  del = function(s)
    -- MAKEIT
  end;

  get = function(s)
    -- MAKEIT
  end;

  send = function(s)
    -- MAKEIT
  end;

  ["!"] = function(s)
    os.execute(s)
  end;

  cls = clrscr_;
  help = help.__help;

  quit = function()
    stat.quit = true
  end;
}
-- Псевдонимы команд
command["?"]  = command.help;
--command.chdir = command.cd;
--command.exit  = command.quit;
--command.ls    = command.dir;
--command.mkdir = command.md;
--command.rm    = command.del;

-- Обработка значений командной строки
function cmdline()
  -- ...
end cmdline()


-- Основная часть программы
function main()
  if stat.host and stat.port then
    -- Попытка соединиться...
  end
  oldattr = getattr_()
  io.write("Welcome to ")
  command.help();
  repeat
    setattr_(0x0A)
    io.write("ftp> ");
    s = read_();
    setattr_(0x0F)
    if s then
      s = s:trimspaces()
      i, j = s:find("([^%s]+)")
      cmd = s:sub(i, j)
      if command[cmd] then
        command[cmd](s:sub(j+1):trimspaces())
      else
        Error_cmd(cmd)
      end
    end
  until stat.quit
  setattr_(oldattr)
end main()
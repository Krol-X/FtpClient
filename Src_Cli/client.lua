-- Цель: ориентир на windows ftp.exe, но с возможностью самому вводить команды
--[[ TODO:
  1. Реализация основных команд
  2. Реализация остальных команд
  3. Реализация cmdline()
]]--
require "luaver"
package.path  = "../?.lua;"..package.path;
package.cpath = "../?.dll;../?5".._VERSION_L()..".dll;"..package.cpath

require "engine"
require "conio"
require "help"

-- Основные команды
command = {
  open = function(s)
    if stat.sock then command.close(true) end
    s = s or ""
    local host, port
    local i, j = s:find("[^%s]+")
    if i then
      host = s:sub(i, j):trimspaces()
      port = s:sub(j+2):trimspaces()
    end
    if not i or host == "" then host = read_("HOST = ") end
    if not tonumber(port) then port = readn_("PORT = ") end
    i = connect(host, port)
    setattr_(i and clok or clerr)
    print(i and "Connected succeful!" or "Connection error!")
    if i then answer.print(receive()) end
  end;

  close = function(s)
    if not stat.sock then if s~=true then Error_con() end return end
    send("quit")
    answer.print(receive())
    stat.sock:close()
    stat.sock = nil
  end;

  user = function(s)
    if not stat.sock then Error_con() return end
    s = s or read_("USER: ")
    send("user "..s)
    local r = receive()
    t = answer.print(r)
    if t == 331 then
      r = readpass_("PASS: ")
      send("pass "..r)
      local r = receive()
      answer.print(r)
    end
  end;

  status = function(s)
    print("Connected: "..(stat.sock and "true" or "false")..';', "Type: "..stat.type)
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

  pwd = function(s)
    if not stat.sock then Error_con() return end
    send("pwd "..topath(s))
    answer.print(receive())
  end;

  dir = function(s)
    if not stat.sock then Error_con() return end
    data_connect()
    send("list "..topath(s))
    print(data_receive())
  end;

  cd = function(s)
    if not stat.sock then Error_con() return end
    send("cwd "..topath(s))
    answer.print(receive())
  end;

  md = function(s)
    if not stat.sock then Error_con() return end
    send("mkd "..topath(s))
    answer.print(receive())
  end;

  del = function(s)
    if not stat.sock then Error_con() return end
    send("dele "..topath(s))
    answer.print(receive())
  end;

  get = function(s)
    if not stat.sock then Error_con() return end
    data_connect()
    -- MAKEIT
  end;

  send = function(s)
    if not stat.sock then Error_con() return end
    data_connect()
    -- MAKEIT
  end;

  ["!"] = function(s)
    os.execute(s)
  end;

  cls = clrscr_;
  help = help.__help;

  quit = function()
    command.close(true)
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
  oldattr = getattr_()
  io.write("Welcome to ")
  command.help(help);
  repeat
    setattr_(clnorm)
    s = read_("ftp> ")
    setattr_(clok)
    if s then
      s = s:trimspaces()
      local i, j = s:find("[^%s]+")
      if i then
        cmd = s:sub(i, j):lower()
        if command[cmd] then
          s = s:sub(j+1):trimspaces()
          command[cmd](s~="" and s or nil)
        else
          Error_cmd(cmd)
        end
      else
        print(s)
      end
    end
  until stat.quit
  setattr_(oldattr)
end main()
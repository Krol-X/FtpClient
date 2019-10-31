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
    s = s or ""
    local host, port = s:trimspaces():match("(.+)%s+(%d+)$")
    if not host and s ~= "" then host = s end
    host, port = host or "", port or ""
    if host == "" then host = read_("HOST = ") end
    if not tonumber(port) then port = readn_("PORT = ") end
    s = control:connect(host, port)
    printclb(s, nil, {"Connected succeful!", "Connection error!"})
    if s then
      answer.print(control:receive())
    end
  end;

  close = function(s)
    if control:connected() then
      control:sendln("quit")
      answer.print(control:receive())
      data:disconnect()
      control:disconnect()
    else
      if s~=true then Error_con() end
    end
  end;

  user = function(s)
    if not control:connected() then Error_con() return end
    s = s or read_("USER: ")
    control:sendln("user "..s)
    local r = control:receive()
    t = answer.print(r)
    if t == 331 then
      r = readpass_("PASS: ")
      control:sendln("pass "..r)
      local r = control:receive()
      answer.print(r)
    end
  end;

  status = function(s)
    print("Connected: "..tostring(control:connected())..';', "Type: "..stat.type)
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
    if not control:connected() then Error_con() return end
    control:sendln("pwd "..topath(s))
    answer.print(control:receive())
  end;

  dir = function(s)
    if not control:connected() then Error_con() return end
    if not data_connect() then return end
    control:sendln("list "..topath(s))
    prints(data:receive('t'))
  end;

  cd = function(s)
    if not control:connected() then Error_con() return end
    control:sendln("cwd "..topath(s))
    answer.print(control:receive())
  end;

  md = function(s)
    if not control:connected() then Error_con() return end
    control:sendln("mkd "..topath(s))
    answer.print(control:receive())
  end;

  del = function(s)
    if not control:connected() then Error_con() return end
    control:sendln("dele "..topath(s))
    answer.print(control:receive())
  end;

  get = function(s)
    if not control:connected() then Error_con() return end
    if not data_connect() then return end
    -- MAKEIT
  end;

  send = function(s)
    if not control:connected() then Error_con() return end
    if not data_connect() then return end
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
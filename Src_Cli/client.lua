-- Цель: ориентир на windows ftp.exe, но с возможностью самому вводить команды
--[[ TODO:
  1. Реализация основных команд
  2. Реализация остальных команд
  3. Реализация cmdline()
]]--
require "luaver"
package.path  = "../?.lua;"..package.path;
package.cpath = "../?.dll;../?5".._VERSION_L()..".dll;"..package.cpath
block_size = 1024

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
    local x = answer.highcode(answer.print(control:receive()))
    if x == 1 or x == 2 then
      prints(data:receive())
    end
    data:disconnect()
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
    s = topath(s)
    control:sendln("retr "..s)
    local x = answer.highcode(answer.print(control:receive()))
    if x == 1 or x == 2 then
      local _, fn = f_path_name(s)
      local f = io.open(fn, "wb")
      setattr_(clpre); io.write("Downloading file")
      local err, fsz = 0, 0
      repeat
        s, err = data:receive(block_size)
        if s then
          f:write(s)
          fsz = fsz + #s
          io.write('.')
        end
      until err
      print()
      setattr_(clok)
      print('Received '..fsz..' bytes of "'..fn..'".')
      f:close()
      answer.print(control:receive())
    end
    data:disconnect()
  end;

  send = function(s)
    if not control:connected() then Error_con() return end
    if not data_connect() then return end
    s = topath(s)
    local _, fn = f_path_name(s)
    local f = io.open(s, "rb")
    if f then
      control:sendln("stor "..fn)
      local x = answer.highcode(answer.print(control:receive()))
      if x == 1 or x == 2 then
        setattr_(clpre); io.write("Uploading file")
        local sz, fsz = 0, 0
        repeat
          s = f:read(block_size)
          if s then
            fsz = fsz + #s
            sz = data:send(s)
            if sz ~= #s then
              Error_up(fn)
              f:close(); return false
            end
            io.write('.')
          end
        until not s
        print()
        setattr_(clok)
        print('Transfered '..fsz..' bytes of "'..fn..'".')
        answer.print(control:receive())
      end
      f:close()
    else
      Error_nofile(s)
    end
    data:disconnect()
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
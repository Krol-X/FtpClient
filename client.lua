--                            --
-- Simple Ftp-Client for lua  --
-- (C) Alex Kondratenko 2019  --
-- mailto: krolmail@list.ru   --
--                            --
-- 
-- io_compatibility = true -- see conio.lua
local pasv
require "include"

stdconfig = {
  welcome = "Welcome to Simple Ftp-Client by _KROL",
  clnorm  = 0x0F,
  clpre   = 0x09,
  clok    = 0x0A,
  clinter = 0x0E,
  clerr   = 0x0C,
  help = { colons = 5, width = 10 }
}
command = {}
control = Sock:new()
data    = Sock:new()
stat = {
  quit    = false,
  type    = "I",
}


local function setaliases()
  command.chdir = command.cd;
  command.down  = command.get;
  command.up    = command.send;
  command.exit  = command.quit;
  command.ls    = command.dir;
  command.mkdir = command.md;
  command.rm    = command.del;
end


local function init()
  local d = lfs.readdir("src")
  for i, x in ipairs(d) do
    local p, f, e = string.splitpath(x)
    if e == "lua" then
      command[f] = require(p..f)
      config[f]  = {}
      config[f].help = command[f].help
    end
  end
  setaliases()
  config.load(stdconfig)
  command["help"].init()
  oldattr = io.getattr()
end init()


color = { -- Временно (пока config.TODO)
  norm  = config.clnorm,
  pre   = config.clpre,
  ok    = config.clok,
  inter = config.clinter,
  err   = config.clerr,
}


local function main()
  io.setattr(config.clnorm)
  print(config.welcome)
  repeat
    io.setattr(color.norm)
    s = io.sread("ftp> "):trimspaces()
    io.setattr(color.ok)
    if s then
      local ss = s:sub(2):trimspaces()
      if s:sub(1, 1) == '~' then
        command["raw"].main(ss)
      elseif s:sub(1, 1) == '?' then
        command["help"].main(ss)
      elseif s:sub(1, 1) == '!' then
        command["exec"].main(ss)
      else
        local i, j = s:find("[^%s]+")
        if i then
          cmd = s:sub(i, j):lower()
          if command[cmd] then
            s = s:sub(j+1):trimspaces()
            command[cmd].main(s~="" and s or nil)
          else
            Error_cmd(cmd)
          end
        end
      end
    end
  until stat.quit
end main()


local function done()
  io.setattr(oldattr)
  config.save()
end done()
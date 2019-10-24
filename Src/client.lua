-- ����: �������� �� windows ftp.exe, �� � ������������ ������ ������� �������
--[[ TODO:
  1. ���������� �������� ������
  2. ���������� ��������� ������
  3. ���������� cmdline()
]]--
--require "socket"
require "tools"
require "wincrt"


-- ����� ������
function Error(s) wincrt.setattr(0x0C) print("Error: "..s) end
function Error_cmd(s) Error('Unknown Command "'..s..'"') end

-- ��������� ���������
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


-- �������� �������
command = {
  ["!"] = function(s)
    os.execute(s)
  end;

--[[
  ascii = function()
    stat.type = "A"
    -- ������ ���� ����������?
  end;
--]]

  binary = function()
    stat.type = "I"
    -- ������ ���� ����������?
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
-- ���������� ������
command["?"]  = command.help;
command.chdir = command.cd;
command.exit  = command.quit;
command.ls    = command.dir;
command.mkdir = command.md;
command.rm    = command.del;
command.rmdir = command.rd;

-- ��������� �������� ��������� ������
function cmdline()
  -- ...
end cmdline()


-- �������� ����� ���������
function main()
  if stat.host and stat.port then
    -- ������� �����������...
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
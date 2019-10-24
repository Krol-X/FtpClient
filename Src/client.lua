-- ����: �������� �� windows ftp.exe, �� � ������������ ������ ������� �������
--[[ TODO:
  1. ���������� �������� ������
  2. ���������� ��������� ������
  3. ���������� cmdline()
]]--
require "engine"
require "conio"
require "help"

-- �������� �������
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
    -- ������ ���� ����������?
  end;

  binary = function()
    stat.type = "I"
    -- ������ ���� ����������?
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
-- ���������� ������
command["?"]  = command.help;
--command.chdir = command.cd;
--command.exit  = command.quit;
--command.ls    = command.dir;
--command.mkdir = command.md;
--command.rm    = command.del;

-- ��������� �������� ��������� ������
function cmdline()
  -- ...
end cmdline()


-- �������� ����� ���������
function main()
  if stat.host and stat.port then
    -- ������� �����������...
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
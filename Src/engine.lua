--require "socket"
require "tools"

-- ��������� ���������
local conn
stat = {
  conn = nil,
  host = nil,
  port = nil,
  quit = false,
  type = "I",
}

-- ����� ������
function Error(s) wincrt.setattr(0x0C) print("Error: "..s) end
function Error_cmd(s) Error('Unknown Command "'..s..'"') end
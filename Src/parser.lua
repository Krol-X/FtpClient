require "tools"

function chktype(x, t) return type(x)==t end
function chkstr(s)
  return not s:match("[0x0A0x0D0x80-0xFF]") and s or nil
end
function chkprstr(s)
  return not s:match("[^0x33-0x7D]") and s or nil
end

local atom = { -- no arguments
  "ABOR", "CDUP", "NOOP", "PASV", "PWD",
  "REIN", "STOU", "SYST", "QUIT" }
      atom = atom:reverse()
local pair = { -- string argument
  "APPE", "CWD", "DELE", "MKD", "PASS", "RETR", "RMD",
  "RNFR", "RNTO", "SITE", "SMNT", "STOR", "USER" }
      pair = pair:reverse()
local apair = { -- [string argument]
  "HELP", "LIST", "NLST", "STAT" }
      apair = apair:reverse()

function parsecmd(s)
  local x, y
  return pcall(function(s)
    local w = s:trimspaces():split();
    local cmd = w[1]:upper()
    if atom[cmd] then
      return cmd
    elseif pair[cmd] or apair[cmd] then
      return cmd, chkstr(s:trimspacese())
    else

    end
  end, s)
end
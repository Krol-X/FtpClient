require "Sock"
require "conio"
require "tools"

-- Состояние программы
control = Sock:new()
data    = Sock:new()
stat = {
  quit    = false,
  type    = "I",
}


-- Вывод ошибок
function Error(s) setattr_(clerr) print("Error: "..s) end --> nil
function Error_cmd(s) Error('Unknown Command "'..s..'"') end --> nil
function Error_con()  Error("Client is not connected!") end --> nil
function Error_cond() Error("Couldn't connect to data socket!") end --> nil
function Error_nofile(s) Error('File "'..s..'" not exists!') end
function Error_up(s)  Error('Upload file "'..s..'" error!') end


function topath(s) --> string
  return s and s:trimspaces():gsub("\\", "/") or "";
end


function f_path_name(s) --> string(path), string(filename)
  return s:match("^%s*(.-)([^\\/]*)$")
end


answer = {
  unpack = function(s) --> number, string
    local i, j = s:find("([^%s-]+)")
    code = assert(tonumber(s:sub(i, j)))
    return code, s:sub(j)
  end;
  highcode = function(x)
    if type(x) == "string" then
      x = answer.unpack(x)
    end; x = x/100
    return x-x%1
  end;
  colorof = function(code) --> number
    if code >= 100 and code < 200 then
      return clpre
    elseif code >= 200 and code < 300 then
      return clok
    elseif code >= 300 and code < 400 then
      return clinter
    else
      return clerr
    end
  end;
  print = function(t) --> number
    local r
    t = type(t) ~= "table" and {t} or t
    table.foreach(t, function(i, s)
      local c, ss = answer.unpack(s)
      setattr_(answer.colorof(c))
      print(s)
      r = c
    end)
    return r
  end;
}


local ippat = "(%d+)%.(%d+)%.(%d+)%.(%d+)"
address = {
  isip = function (s) local i, j = s:find(ippat); return i == 1 and j == #s end; --> boolean
  splitip = function(s) return s:match(ippat) end; --> ip3, ip2, ip1, ip0
  getip_pasv = function(s) --> string, number
    local d, c, b, a, y, x = s:match("(%d+),(%d+),(%d+),(%d+),(%d+),(%d+)")
    return d..'.'..c..'.'..b..'.'..a, y*256+x
  end;
}


local data_con = false
function data_connect() --> boolean
  local s, err
  if data:connected() then return end
--if data_con then
--  data:connect()
--else
    control:sendln("pasv")
    s, err = control:receive('s')
    if answer.highcode(s) == 2 then
      if err or not data:connect(address.getip_pasv(s)) then
        Error_cond(); return false
      end
    else
      return false
    end
--end
  answer.print(control:receive())
  data_con = data:connected()
  return true
end
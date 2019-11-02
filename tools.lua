function Error(s) io.setattr(color.err) print("Error: "..s) end
function Error_cmd(s)  Error('Unknown Command "'..s..'"') end
function Error_con()   Error("Client is not connected!") end
function Error_dcon()  Error("Couldn't connect to data socket!") end
function Error_file(s) Error('File "'..s..'" not exists!') end --> nil


answer = {
  unpack = function(s) --> number, string
    local i, j = s:find("([^%s-]+)")
    code = assert(tonumber(s:sub(i, j)))
    return code, s:sub(j)
  end;
  highcode = function(x) --> number
    if type(x) == "string" then
      x = answer.unpack(x)
    end; x = x/100
    return x-x%1
  end;
  colorof = function(code) --> number
    if code >= 100 and code < 200 then
      return color.pre
    elseif code >= 200 and code < 300 then
      return color.ok
    elseif code >= 300 and code < 400 then
      return color.inter
    else
      return color.err
    end
  end;
  print = function(t) --> number
    local r
    t = type(t) ~= "table" and {t} or t
    table.foreach(t, function(i, s)
      local c, ss = answer.unpack(s)
      io.setattr(answer.colorof(c))
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


--local _pasv = false
pasv = function()
  assert(control:connected())
  --if not _pasv then
    control:sendln("pasv")
    local r = control:receive()
    if answer.highcode(r[#r]) < 3 then
      data:init(address.getip_pasv(r[#r]))
    else
      answer.print(r)
    end
  --  _pasv = true
  --end
end
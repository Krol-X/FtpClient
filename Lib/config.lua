--                             --
-- config file support for lua --
-- (C) Alex Kondratenko 2019   --
-- mailto: krolmail@list.ru    --
--                             --
-- TODO: save table.values
local stdfn = "config.ini"; config = {}


function config.load(stdcfg, fn)
  local _config = {}
  local f = loadfile(fn or stdfn, "t", _config)
  if f then f() end
  for k, v in pairs(stdcfg) do
    config[k] = (type(_config[k]) == type(stdconfig[k]))
                and _config[k] or stdconfig[k]
  end
end


function config.save(fn)
  local f = io.open(fn or stdfn, "w")
  local strs = {}
  for k, v in pairs(config) do
    local t = type(v);
    local isStr = (t == "string")
    if t == "number"
    or t == "boolean"
    or t == "string" then
      t = {}
      table.insert(t, k)
      table.insert(t, ' = ')
      table.insert(t, isStr and '"' or nil)
      table.insert(t, tostring(v))
      table.insert(t, isStr and '"' or nil)
      table.insert(t, '\n')
      t = table.concat(t)
    else
      t = nil
    end
    table.insert(strs, t)
  end
  table.sort(strs, function(a, b) return a<b end)
  f:write(table.concat(strs))
  f:close()
end
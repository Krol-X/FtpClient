--                            --
-- ktools library for lua     --
-- (C) Alex Kondratenko 2019  --
-- mailto: krolmail@list.ru   --
--                            --
ktools = { version = 0.1 }

local lib = {}
      lib.io = {
      -- sread(s) --> string
      -- nread(s) --> number
      }
      lib.math = {
      -- divide(x, y) --> number(division), number(remain)
--v<5.3-- tointeger(n) --> integer
      }
      lib.os = {
      -- delay(ms) --> nil
      }
      lib.string = {
      -- setchar(str, pos, x) --> string
      -- split(s, sep) --> table
      -- splitpath(s)  --> string(dir), string(name), string(ext)
      -- toupath(s)    --> string
      -- towpath(s)    --> string
      -- trimspaces(s) --> string
      }
      lib.table = {
      -- copy(t)       --> table
      -- foreach(t, f) --> nil
      -- reverse(t)    --> table
      -- string(t, tab, first) --> string
      -- unpack(t, i, n)       --> ...
      }
      lib.lfs = {
      -- readdir(path)  --> table(files), table(subdirs)
      -- printdir(only) --> nil
      }
      lib.extra = {
      -- comparg(t, ...) --> boolean
      -- require(...)    --> nil
      }


ktools.install = function(t, r, w) --> nil
  local ver = ktools.version; local kt = "KTools("..ver.."):"
  t = t or _G
  for cat, x in pairs(lib) do
    if not t[cat] then t[cat] = {} if w then print(kt.."Creating non-existed category "..cat) end end
    local old = t[cat].__ktools
    if old ~= ver then
      if w and old then print(kt.."Replacing category of version "..old) end
      for n, f in pairs(x) do
        t[cat][n] = t[cat][n] and (r and f or t[cat][n]) or f
      end
      t[cat].__ktools = ver
    end
  end
end


ktools.uninstall = function(t, w) --> nil
  local ver = ver
  t = t or _G
  for cat, x in pairs(lib) do
    if t[cat] then
      local old = t[cat].__ktools
      if old ~= ver then
        if w and old then print("KTools("..ver.."): Deleting category of version "..old) end
        for n, f in pairs(x) do
          t[cat][n] = nil
        end
        t[cat].__ktools = nil
      end
    end
  end
end




----            ----
----   lib.io   ----
----            ----

function lib.io.sread(s) --> string
  if s then
    local i, x
    repeat
      io.write(s)
      i, x = pcall(lib.io.sread)
    until #x>0
    return x
  else
    io.flush()
    return io.read('*l')
  end
end


function lib.io.nread(s) --> number
  if s then
    local i, x
    repeat
      io.write(s)
      i, x = pcall(lib.io.nread)
    until i
    return x
  else
    io.flush()
    return io.read('*n')
  end
end




----            ----
----  lib.math  ----
----            ----

function lib.math.divide(x, y) --> number(division), number(remain)
  local z = x/y
  return z-z%1, x-y*(z-z%1)
end


-- Compatibility with Lua < 5.3 and round function :)
if _VERSION_I<53 then
  function lib.math.tointeger(n) --> integer
    return n-n%1
  end
end


----            ----
----   lib.os   ----
----            ----

function lib.os.delay(ms) --> nil
  ms = ms or 1.0
  local t0 = os.clock()
  while os.clock()-t0 < ms do end
end




----            ----
---- lib.string ----
----            ----

function lib.string.setchar(str, pos, x) --> string
    return ("%s%s%s"):format(str:sub(1,pos-1), x, str:sub(pos+1))
end


function lib.string.split(s, sep) --> table
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(s, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end


function lib.string.splitpath(s) --> string(dir), string(name), string(ext)
  s = s or ""
  local path, fn, name, ext
  path, fn = s:match("^%s*(.-)([^\\/]*)$")
  if fn then
    name, ext = fn:match("([^%.]*)%.?(.*)$")
  end
  return path, name, ext
end


function lib.string.toupath(s) --> string
  return s and s:trimspaces():gsub("\\", "/") or "";
end


function lib.string.towpath(s) --> string
  return s and s:trimspaces():gsub("/", "\\") or "";
end


function lib.string.trimspaces(s) --> string
  return s:match("^%s*(.*)%s*$")
end




----            ----
---- lib.table  ----
----            ----

function lib.table.copy(t) --> table
  local t2 = {};
  for k, v in pairs(t) do
    t2[k] = (type(v) == "table") and table.copy(v) or v
  end
  setmetatable(t2, getmetatable(t))
  return t2;
end


function lib.table.foreach(t, f) --> nil
  for k, v in pairs(t) do f(k, v) end
end


function lib.table.reverse(t) --> table
  t2 = {}; for k, v in pairs(t) do t2[v] = k end
  return t2
end


function lib.table.string(t, tab, first) --> string
  local pretty = tab ~= nil
  first = first or 0
  tab = (type(tab)=="number" and tab >= 0) and tab or 0
  local _tab = string.rep(' ', tab)
  local ident, r = string.rep(_tab, first), {}
  if type(t) == 'table' then
    table.insert(r, "{")
    table.insert(r, pretty and "\n"..ident.._tab or nil)
    local s = ""
    for k, v in pairs(t) do
      if type(k) ~= "number" then k = table.concat({'"', k, '"'}) end
      s = '['..k..'] = ' .. lib.table.string(v, pretty and tab or nil, first+1)
      table.insert(r, s)
      table.insert(r, ', ')
    end
    table.remove(r)
    table.insert(r, pretty and "\n"..ident or nil)
    table.insert(r, "}")
    return table.concat(r)
  else
    if type(t) ~= "number" then t = table.concat({'"', tostring(t), '"'}) end
    return tostring(t)
  end
end


function lib.table.unpack(t, i, n) --> ...
  i = i or 1
  n = n or #t
  if i <= n then
    return t[i], lib.table.unpack(t, i+1, n)
  end
end




----            ----
----  lib.lfs   ----
----            ----

function lib.lfs.readdir(path) --> table(files), table(subdirs)
  path = path or '.'
  local files, dirs = {}, {}
  for f in lfs.dir(path) do
    if f ~= '.' and f ~= '..' then
      if lfs.attributes(path..'/'..f, "mode") == "file" then
        table.insert(files, f)
      else
        table.insert(dirs, f..'/')
      end
    end
  end
  return files, dirs
end


function lib.lfs.printdir(only) --> nil
    local file, dir = readDir(dir_path)
  if only ~= "files" then
    for i, x in pairs(dir) do
      io.write("[", string.sub(x, 1, #x-1), "]\n")
    end
  end
  if only ~= "dirs" then
    for i, x in pairs(file) do io.write(x, "\n") end
  end
end




----            ----
---- lib.extra  ----
----            ----

function lib.extra.comparg(t, ...) --> boolean
  local t2 = {...}
  for i, v in ipairs(t) do
    if t2[i] and t2[i] ~= v then return false end
  end
  return true
end


function lib.extra.require(...) --> nil
  for _, x in pairs{...} do
    if type(x) == "string" then
      require(x)
    elseif type(x) == "table" then
      lib.extra.require(lib.table.unpack(x))
    end
  end
end
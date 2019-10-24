table.unpack = table.unpack or function (t, i, n)
  i = i or 1
  n = n or #t
  if i <= n then
    return t[i], unpack(t, i+1, n)
  end
end

function table.copy(t)
  local t2 = {};
  for k, v in pairs(t) do
    if type(v) == "table" then
      t2[k] = table.copy(v);
    else
      t2[k] = v;
    end
  end
  setmetatable(t2, getmetatable(t))
  return t2;
end

function table.reverse(t)
  t2 = {}
  for k, v in pairs(t) do t2[v] = k end
  return t2
end

function string.split(s, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(s, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

function string.trimspaces(s)
  return s:match("^%s*(.*)%s*$")
end
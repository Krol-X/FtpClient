function _VERSION_()
  local s = _VERSION
  return tonumber(s:match("%s.+$"):sub(2))
end


_VERSION_L = _VERSION_()*10%10

-- Compatibility with Lua < 5.3
local toint = math.tointeger or function (x) return x end

_VERSION_I = toint(_VERSION_()*10); _VERSION_I = _VERSION_I - _VERSION_I%1
function _VERSION_()
  local s = _VERSION
  return tonumber(s:match("%s.+$"):sub(2))
end


function _VERSION_L()
  return _VERSION_()*10%10
end

_VERSION_I = _VERSION_()*10; _VERSION_I = _VERSION_I - _VERSION_I%1
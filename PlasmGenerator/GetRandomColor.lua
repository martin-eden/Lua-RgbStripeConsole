-- Return random color respecting max color component value

-- Last mod.: 2024-11-06

return
  function(self)
    local MaxVal = self.MaxColorComponentValue
    local Random = math.random

    return
      {
        Red = Random(0, MaxVal),
        Green = Random(0, MaxVal),
        Blue = Random(0, MaxVal),
      }
  end

--[[
  2024-09-30
  2024-11-06
]]

-- Return random color respecting max color component value

--[[
  Input

    self
      MaxColorComponentValue

  Output

    { Red = (:byte), Green = (:byte), Blue = (:byte) }
]]

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

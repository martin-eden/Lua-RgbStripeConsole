-- Reset pixels

-- Last mod.: 2025-11-12

-- Reset makes pixels black but does not affect LED until Display()

return
  function(self)
    self:WriteCommand('C')
  end

--[[
  2024-09-18
  2024-10-24
]]

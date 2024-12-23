-- Reset pixels

-- Last mod.: 2024-12-23

-- Reset makes pixels black but does not affect LED until Display()

return
  function(self)
    self:WriteCommand('R')
  end

--[[
  2024-09-18
  2024-10-24
]]

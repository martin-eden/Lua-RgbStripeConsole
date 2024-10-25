-- Write command to reset stripe

-- Last mod.: 2024-10-25

-- Reset makes pixels black but does not affect LED until Display()

return
  function(self)
    self:WriteItem('R')
  end

--[[
  2024-09-18
  2024-10-24
]]

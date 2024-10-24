-- Write command to reset stripe

-- Reset makes pixels black but does not affect LED until Display()

return
  function(self)
    self:WriteLine('( R )')
  end

--[[
  2024-09-18
  2024-10-24
]]

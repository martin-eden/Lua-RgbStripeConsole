-- Write command to make delay in milliseconds

-- Last mod.: 2024-10-29

--[[
  If you want to directly write to device, override :WriteItem() and
  make this method to actually delay.
]]

-- Exports:
return
  function(self, Delay_Ms)
    assert_integer(Delay_Ms)
    assert(Delay_Ms >= 0)

    self:WriteItem(self.DelayCommand .. ' ' .. tostring(Delay_Ms))
  end

--[[
  2024-10-29
]]

-- [handy] Print string and newline to <.Output>

return
  function(self, String)
    self.Output:Write(String)
    self.Output:Write('\n')
  end

--[[
  2024-09-18
  2024-09-30
]]

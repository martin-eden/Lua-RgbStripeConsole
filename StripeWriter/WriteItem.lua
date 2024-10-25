-- [Internal] Wrap string as item and send to <.Output>

local Trim = request('!.string.trim')

return
  function(self, String)
    String = Trim(String)
    self.Output:Write('( ')
    self.Output:Write(String)
    self.Output:Write(' )\n')
  end

--[[
  2024-09-18
  2024-09-30
  2024-10-25
]]

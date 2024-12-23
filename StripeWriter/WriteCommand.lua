-- Send string to device

-- Last mod.: 2024-12-24

--[[
  Send string to <.Output>

  We're expecting that data is sent to device. So we're adding
  tail delimiter to make it clear that last item is ended.

  For some reasons it only works when we adding small time delay
  between commands.
]]
local WriteCommand =
  function(self, CommandStr)
    self.Output:Write(CommandStr)
    self.Output:Write('\n')

    self:Delay_Ms(1)

    -- print('> ' .. CommandStr)
  end

-- Exports:
return WriteCommand

--[[
  2024-09 # #
  2024-10 # #
  2024-12-23
]]

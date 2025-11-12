-- Send string to device

-- Last mod.: 2025-11-12

--[[
  Send command and data strings to <.Output>

  We're expecting that data is sent to device. So we're adding
  tail delimiter to make it clear that last item is ended.

  Firmware parsing became slower from 2024 to 2025.
  Now it needs additional delay between command and data
  when operating at 115200 bps.
]]
local WriteCommand =
  function(self, CommandStr, DataStr)
    self.Output:Write(CommandStr)
    if DataStr then
      self.Output:Write(' ')
      self:Delay_Ms(1)
      self.Output:Write(DataStr);
    end
    self.Output:Write('\n')
    self:Delay_Ms(1)

    -- print('> ' .. CommandStr .. ' ' .. (DataStr or 'nil'))
  end

-- Exports:
return WriteCommand

--[[
  2024-09 # #
  2024-10 # #
  2024-12-23
]]

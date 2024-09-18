-- Write string to UART device. Implements [StreamIo.Output]

local Write =
  function(self, Data)
    return self.BorrowedFileOutput:Write(Data)
  end

-- Exports:
return Write

--[[
  2024-09-18
]]

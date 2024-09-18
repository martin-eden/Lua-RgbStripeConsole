-- Read from UART device. Implements [StreamIo.Input]

local Read =
  function(self, NumBytes)
    return self.BorrowedFileInput:Read(NumBytes)
  end

-- Exports:
return Read
--[[
  2024-09-18
]]

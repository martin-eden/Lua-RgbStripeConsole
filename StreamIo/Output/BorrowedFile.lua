-- Output interface for already opened file

local FileOutput = request('!.concepts.StreamIo.Output.File')

--[[
  Contract: Write string

  Implementation piggybacks on [StreamIo.Output.File].
]]
local Write =
  function(self, Data)
    FileOutput.File = self.FileHandle
    local NumBytesWritten, IsComplete = FileOutput:Write(Data)
    FileOutput.File = nil
    return NumBytesWritten, IsComplete
  end

-- Exports:
return
  {
    -- Contract:
    Write = Write,

    -- Intestines management:
    -- Just file handle we're passing to file writer
    FileHandle = nil,
  }

--[[
  2024-09-18
]]

-- Read from already opened file

--[[
  Actually it's subset of [StreamIo.Input.File] without file
  opening and closing methods.

  I still consider they should belong to base [File], and this
  interface is a special case for device files.
]]

local FileInput = request('!.concepts.StreamIo.Input.File')

--[[
  Contract: Read string from file

  Implementation piggybacks on [StreamIo.Input.File].
]]
local Read =
  function(self, NumBytes)
    FileInput.File = self.FileHandle

    local Data, IsComplete = FileInput:Read(NumBytes)

    FileInput.File = nil

    return Data, IsComplete
  end

-- Exports:
return
  {
    -- Contract:
    Read = Read,

    -- Intestines management:
    -- No methods, we're just passing this file handle
    FileHandle = nil,
  }

--[[
  2024-09-18
]]

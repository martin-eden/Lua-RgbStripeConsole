-- Open file. Parse "Itness" format, send items to <.Output>. Close file.

-- Last mod.: 2024-11-11

-- Imports:
local Input = request('!.concepts.StreamIo.Input.File')
local Parser = request('!.concepts.Itness.Parser.Interface')

local SendFile =
  function(self, FileName)
    Input:Open(FileName)

    -- Parse "Itness" to list of items
    Parser.Input = Input
    local Items = Parser:Run()

    Input:Close()

    self:SendItem(Items)
  end

-- Exports:
return SendFile

--[[
  2024-09-18
  2024-10-24
  2024-11-11
]]

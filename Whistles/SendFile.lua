-- Open file. Parse "Itness" format, send items <Output>. Close file.

-- Last mod.: 2024-11-11

-- Imports:
local Input = request('!.concepts.StreamIo.Input.File')
local Parser = request('!.concepts.Itness.Parser.Interface')

local SendFile =
  function(self, FileName, Output)
    print(string.format('( Processing file "%s".', FileName))

    Input:Open(FileName)

    -- Parse "Itness" to list of items
    Parser.Input = Input
    local Items = Parser:Run()

    Input:Close()

    self:SendItem(Items, Output)

    print(string.format(') Processed file "%s".', FileName))
  end

-- Exports:
return SendFile

--[[
  2024-09-18
  2024-10-24
]]

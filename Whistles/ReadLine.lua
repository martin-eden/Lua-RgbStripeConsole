-- Read line from file handle with stdout echo

-- Last mod.: 2024-11-11

-- Imports:
local AssertClassIs = request('!.concepts.Class.AssertIs')
local InputFileInterface = request('!.concepts.StreamIo.Input.File')

--[[
  Read line from file handle with echo for human.

  If there are no line, return nil.
]]
local ReadLine =
  function(self, Input)
    AssertClassIs(Input, InputFileInterface)

    local Line = Input.FileHandle:read('l')

    if not Line then
      return
    end

    local PrintLineFormat =
      '> [ %s ]'

    print(string.format(PrintLineFormat, Line))

    return Line
  end

-- Exports:
return ReadLine

--[[
  2024-09-18
  2024-10-24
]]

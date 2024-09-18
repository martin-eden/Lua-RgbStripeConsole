-- Read lines from input

--[[
  Read lines from input and return them as table sequence

  For the sake of first implementation I'm using file handle,
  not [StreamIo.Input]. Because Lua's file handle have "lines" method
  while [Input] doesn't. (And probably shouldn't. There should be
  something of higher order for this. Like [StreamIo.Lines.Input].)
]]
local ReadLines =
  function(self, FileHandle)
    local Lines = {}

    while self:ReadLine(FileHandle) do
      table.insert(Lines, Line)
    end

    return Lines
  end

-- Exports:
return ReadLines

--[[
  2024-09-18
]]

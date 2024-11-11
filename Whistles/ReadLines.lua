-- Read lines from input

-- Last mod.: 2024-11-11

--[[
  Read lines from input and return them as table sequence
]]
local ReadLines =
  function(self, Input)
    local Lines = {}

    while self:ReadLine(Input) do
      table.insert(Lines, Line)
    end

    return Lines
  end

-- Exports:
return ReadLines

--[[
  2024-09-18
  2024-11-11
]]

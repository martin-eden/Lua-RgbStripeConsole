-- Serialize color record

-- Last mod.: 2024-12-23

-- Imports:
local UnpackColor = request('UnpackColor')

--[[
  Serialize color table to string

  { Red = 1, Green = 20, Blue = 140 } -> "001 020 140"

  But numbers formatting is a matter of taste.
]]
local SerializeColor =
  function(Color)
    local Red, Green, Blue = UnpackColor(Color)
    local ColorStrFmt = '%03d %03d %03d'
    local Result = string.format(ColorStrFmt, Red, Green, Blue)

    return Result
  end

-- Exports:
return SerializeColor

--[[
  2024-09-30
  2024-12-23
]]

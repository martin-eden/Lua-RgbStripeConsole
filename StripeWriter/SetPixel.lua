-- Set pixel color

-- Last mod.: 2025-11-12

-- Imports:
local GetIndex = request('Internals.GetIndex')
local SerializeColor = request('Internals.SerializeColor')

--[[
  Set pixel at given index to given color

  Input

    Index: word - pixel index
    Color: TColor - pixel color
]]
local SetPixel =
  function(self, Index, Color)
    local Index = GetIndex(Index)
    local ColorStr = SerializeColor(Color)

    local DataFormat = '%03d  %s'
    local DataStr = string.format(DataFormat, Index, ColorStr)

    self:WriteCommand('SP', DataStr)
  end

-- Exports:
return SetPixel

--[[
  2024-09 # #
  2024-10 #
  2024-12-23
]]

-- Set segment of pixels

-- Last mod.: 2025-11-12

-- Imports:
local GetIndex = request('Internals.GetIndex')
local SerializeColor = request('Internals.SerializeColor')

--[[
  Set segment of pixels to given colors

  Input

    StartIndex: word - first index of range
    Colors: { TColor .. } - colors of pixels in range
]]
local SetPixels =
  function(self, StartIndex, Colors)
    assert_table(Colors)
    assert(#Colors >= 1)

    local StartIndex = GetIndex(StartIndex)
    local StopIndex = StartIndex + #Colors - 1

    local DataStr = ''

    -- Add header
    do
      local HeaderFmt = '%03d %03d'
      local HeaderStr = string.format(HeaderFmt, StartIndex, StopIndex)

      DataStr = HeaderStr
    end

    -- Serialize pixel colors
    do
      local Chunks = {}

      for _, Color in ipairs(Colors) do
        local ColorStr = SerializeColor(Color)
        table.insert(Chunks, ColorStr)
      end

      local ColorsStr = table.concat(Chunks, '  ')

      DataStr = DataStr .. '  ' .. ColorsStr
    end

    self:WriteCommand('SPR', DataStr)
  end

-- Exports:
return SetPixels

--[[
  2024-09 #
  2024-10 # #
  2024-12-23
]]

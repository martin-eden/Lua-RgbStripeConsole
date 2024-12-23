-- Set segment of pixels

-- Last mod.: 2024-12-23

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

    local Command = ''

    -- Add header
    do
      local HeaderFmt = 'SPR %03d %03d'
      local HeaderStr = string.format(HeaderFmt, StartIndex, StopIndex)

      Command = HeaderStr
    end

    -- Serialize pixel colors
    do
      local Chunks = {}

      for _, Color in ipairs(Colors) do
        local ColorStr = SerializeColor(Color)
        table.insert(Chunks, ColorStr)
      end

      local ColorsStr = table.concat(Chunks, '  ')

      Command = Command .. '  ' .. ColorsStr
    end

    self:WriteCommand(Command)
  end

-- Exports:
return SetPixels

--[[
  2024-09 #
  2024-10 # #
  2024-12-23
]]

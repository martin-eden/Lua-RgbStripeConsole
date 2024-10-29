-- Write command to set a range of pixels

-- Last mod.: 2024-10-25

--[[
  Input

    {
      StartIndex: word - first index of range
      StopIndex: word - last index of range
      Colors: { TColor .. } - colors of pixels in range
        TColor - see [Interface] for format
    }

  Errors policy

    Explode with error().
]]

-- Imports:
local GetIndex = request('Internals.GetIndex')
local UnpackColor = request('Internals.UnpackColor')
local GetListChunk = request('!.concepts.List.GetChunk')

return
  function(self, Args)
    assert_table(Args)

    local StartIndex = GetIndex(Args.StartIndex)
    local StopIndex = GetIndex(Args.StopIndex)
    local Length = StopIndex - StartIndex + 1

    assert(StartIndex <= StopIndex)

    local Colors = Args.Colors
    assert_table(Colors)

    -- Make sure we have exact number of colors for stride
    assert(#Colors == Length)

    -- Unpack colors and represent them as string
    local ColorsStr
    do
      local FlattenedColors = {}

      for Index, Color in ipairs(Colors) do
        local Red, Green, Blue = UnpackColor(Color)

        local ColorStrFormat =
          '%03d %03d %03d'
        local ColorStr =
          string.format(ColorStrFormat, Red, Green, Blue)

        table.insert(FlattenedColors, ColorStr)
      end

      ColorsStr = table.concat(FlattenedColors, '  ')
    end

    local CommandFormat =
      'SPR %03d %03d  %s'

    local Command =
      string.format(
        CommandFormat,
        StartIndex,
        StopIndex,
        ColorsStr
      )

    self:WriteItem(Command)
  end

--[[
  2024-09-30
  2024-10-03
  2024-10-24
]]

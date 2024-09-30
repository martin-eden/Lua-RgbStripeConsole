-- Write command to set a range of pixels

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

local GetIndex = request('Internals.GetIndex')
local UnpackColor = request('Internals.UnpackColor')

return
  function(self, Args)
    assert_table(Args)

    local StartIndex = GetIndex(Args.StartIndex)
    local StopIndex = GetIndex(Args.StopIndex)

    assert(StartIndex <= StopIndex)

    local Colors = Args.Colors
    assert_table(Colors)

    local ColorsStr
    do
      local FlattenedColors = {}

      for Index, Color in ipairs(Colors) do
        local Red, Green, Blue = UnpackColor(Color)

        table.insert(FlattenedColors, Red)
        table.insert(FlattenedColors, Green)
        table.insert(FlattenedColors, Blue)
      end

      ColorsStr = table.concat(FlattenedColors, ' ')
    end

    local CommandFormat =
      'SPR %d %d %s'

    local Command =
      string.format(
        CommandFormat,
        StartIndex,
        StopIndex,
        ColorsStr
      )

    self:WriteLine(Command)
  end

--[[
  2024-09-30
]]

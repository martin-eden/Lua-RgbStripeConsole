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
    local Length = StopIndex - StartIndex + 1

    assert(StartIndex <= StopIndex)

    local Colors = Args.Colors
    assert_table(Colors)

    -- Make sure we have exact number of colors for stride
    assert(#Colors == Length)

    --[[
      Real world. If we will send long line to Arduino, most
      of it will be lost. To stay safe we need to send lines
      under 64 bytes (Arduino's serial buffer size).

      So one call of SetPixels() will split to several "SPR" commands.

      We'll use recursion here.

      Recursion depth is ((NumPixels / NumPixelsPerChunk) - 1).

      Memory consumption is quadratic of recursion depth. That's
      bad but should be acceptable for practical cases.
    ]]
    do
      local NumPixelsPerChunk = 4
      if (Length > NumPixelsPerChunk) then
        -- Call ourselves with first chunk
        local Head = {}
        Head.StartIndex = StartIndex
        Head.StopIndex = StartIndex + NumPixelsPerChunk - 1
        Head.Colors = {}
        table.move(Colors, 1, NumPixelsPerChunk, 1, Head.Colors)
        self:SetPixels(Head)

        -- Call ourselves with chopped remainder
        local Tail = {}
        Tail.StartIndex = StartIndex + NumPixelsPerChunk
        Tail.StopIndex = StopIndex
        Tail.Colors = {}
        table.move(Colors, NumPixelsPerChunk + 1, Length, 1, Tail.Colors)
        self:SetPixels(Tail)

        -- We won't fall-through
        return
      end
    end

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

    self:WriteLine(Command)
  end

--[[
  2024-09-30
]]

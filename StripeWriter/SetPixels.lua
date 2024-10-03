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

    --[[
      Real world. If we will send long line to Arduino, most
      of it will be lost. To stay safe we need to send lines
      under 64 bytes (Arduino's serial buffer size).

      This block splits data to chunks and does self calls.
    ]]
    do
      local NumPixelsPerChunk = 4
      if (Length > NumPixelsPerChunk) then
        local Chunk =
          {
            StartIndex = StartIndex,
            StopIndex = 0,
            Colors = {},
          }

        while (Chunk.StartIndex <= StopIndex) do
          Chunk.StopIndex = Chunk.StartIndex + NumPixelsPerChunk - 1
          if (Chunk.StopIndex > StopIndex) then
            Chunk.StopIndex = StopIndex
          end
          local Colors_StartIndex = Chunk.StartIndex - StartIndex + 1
          local Colors_StopIndex = Chunk.StopIndex - StartIndex + 1
          Chunk.Colors = GetListChunk(Colors, Colors_StartIndex, Colors_StopIndex)
          self:SetPixels(Chunk)
          Chunk.StartIndex = Chunk.StopIndex + 1
        end

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
  2024-10-03
]]

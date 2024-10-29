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

-- Convert color record to string like '255 000 255'
local GetColorStr =
  function(Color)
    local ColorStrFmt = '%03d %03d %03d'
    local Red, Green, Blue = UnpackColor(Color)
    return string.format(ColorStrFmt, Red, Green, Blue)
  end

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

    local Lines = {}
    local Chunk = {}
    local ChunkSize = 4

    for Index, Color in ipairs(Colors) do
      local ColorStr = GetColorStr(Color)
      table.insert(Chunk, ColorStr)

      if (Index % ChunkSize == 0) then
        local Line = '  ' .. table.concat(Chunk, '  ')
        table.insert(Lines, Line)
        Chunk = {}
      end
    end

    local CommandHeaderFmt =
      'SPR %03d %03d'

    local CommandHeaderStr =
      string.format(CommandHeaderFmt, StartIndex, StopIndex);

    local DataStr = table.concat(Lines, '\n')

    local CommandStr = CommandHeaderStr .. '\n' .. DataStr .. '\n'

    self:WriteItem(CommandStr)
  end

--[[
  2024-09-30
  2024-10-03
  2024-10-24
]]

-- Write command to set pixel at given index

local GetIndex = request('Internals.GetIndex')
local UnpackColor = request('Internals.UnpackColor')

--[[
  Set pixel at given index to given color.

  Input

    {
      Index: word - pixel index
      Color: TColor - pixel color
        TColor - see [Interface] for format
    }

  Errors policy

    Explode with error().
]]
return
  function(self, Pixel)
    assert_table(Pixel)

    local Index = GetIndex(Pixel.Index)

    local Red, Green, Blue = UnpackColor(Pixel.Color)

    local CommandFormat =
      'SP %03d  %03d %03d %03d'

    local Command =
      string.format(
        CommandFormat,
        Index,
        Red,
        Green,
        Blue
      )

    self:WriteLine(Command)
  end

--[[
  2024-09-18
  2024-09-30
]]

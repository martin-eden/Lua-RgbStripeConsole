-- Write command to set pixel at given index

--[[
  Write command to set pixel at given index to given color.

  Input

    {
      Index - int - pixel index
      Color - pixel color:
        {
          Red - int
          Green - int
          Blue - int
        }
    }
]]
return
  function(self, Pixel)
    local CommandFormat =
      'SP %03d  %03d %03d %03d'

    local Command =
      string.format(
        CommandFormat,
        Pixel.Index,
        Pixel.Color.Red,
        Pixel.Color.Green,
        Pixel.Color.Blue
      )

    self:WriteLine(Command)
  end

--[[
  2024-09-18
]]

-- Calculate midway pixel with noise

local GetGap = request('Internals.GetGap')
local GetMiddle = request('Internals.GetMiddle')
local Clamp = request('Internals.Clamp')

--[[
  Mix color components with adding calculated noise

  Input

    ColorA: byte
    ColorB: byte
    Noise: float [-1.0, +1.0]
    MaxColor: byte -- max color component value
]]
local Mix =
  function(ColorA, ColorB, Noise, MaxColor)
    local ColorNoise = math.floor(Noise * MaxColor)

    local Result
    Result = GetMiddle(ColorA, ColorB) + ColorNoise
    Result = Clamp(Result, 0, MaxColor)

    return Result
  end

--[[
  Given left and right pixels calculate midway pixel, adding
  distance-dependent noise and static noise. Apply scaling factor.

  Type TPixel

    {
      Index: int,
      Color: { Red, Green, Blue: int }
    }

  Input

    LeftPixel, RightPixel: TPixel

    self
      MaxColorComponentValue: byte

  Output

    TPixel
]]
return
  function(self, LeftPixel, RightPixel)
    local Gap = GetGap(LeftPixel.Index, RightPixel.Index)
    assert(Gap >= 1)

    -- Distance is normalized gap to make it fit in [0.0, 1.0]
    local Distance = Gap / self.MaxGap

    local MaxColor = self.MaxColorComponentValue

    return
      {
        Index = GetMiddle(LeftPixel.Index, RightPixel.Index),
        Color =
          {
            Red =
              Mix(
                LeftPixel.Color.Red,
                RightPixel.Color.Red,
                self:MakeDistanceNoise(Distance),
                MaxColor
              ),
            Green =
              Mix(
                LeftPixel.Color.Green,
                RightPixel.Color.Green,
                self:MakeDistanceNoise(Distance),
                MaxColor
              ),
            Blue =
              Mix(
                LeftPixel.Color.Blue,
                RightPixel.Color.Blue,
                self:MakeDistanceNoise(Distance),
                MaxColor
              ),
          },
      }
  end

--[[
  2024-09-30
]]

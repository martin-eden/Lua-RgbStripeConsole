-- Calculate midway pixel with noise

-- Last mod.: 2024-11-06

-- Imports:
local GetGap = request('Internals.GetGap')
local GetMiddle = request('Internals.GetMiddle')
local Clamp = request('Internals.Clamp')
local Floor = math.floor

--[[
  Mix values with noise

  Noise is float in [-1.0, 1.0].
]]
local Mix =
  function(Value_A, Value_B, Noise, MaxValue)
    local Value_Noise = Floor(Noise * MaxValue)

    local Result
    Result = GetMiddle(Value_A, Value_B) + Value_Noise
    Result = Clamp(Result, 0, MaxValue)

    return Result
  end

--[[
  Given left and right pixels calculate midway pixel, adding
  distance-dependent noise. Apply scaling factor.

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
local CalculateMidwayPixel =
  function(self, LeftPixel, RightPixel)
    local Gap = GetGap(LeftPixel.Index, RightPixel.Index)
    assert(Gap >= 1)

    -- Distance is normalized gap to make it fit in [0.0, 1.0]
    local Distance = Gap / self.MaxGap

    -- Index of middle pixel
    local Index = GetMiddle(LeftPixel.Index, RightPixel.Index)

    local MaxValue = self.MaxColorComponentValue

    --[[
      Calculate color components. Note that noise will be different
      for each component.
    ]]
    local Red, Green, Blue
    do
      Red =
        Mix(
          LeftPixel.Color.Red,
          RightPixel.Color.Red,
          self:MakeDistanceNoise(Distance),
          MaxValue
        )
      Green =
        Mix(
          LeftPixel.Color.Green,
          RightPixel.Color.Green,
          self:MakeDistanceNoise(Distance),
          MaxValue
        )
      Blue =
        Mix(
          LeftPixel.Color.Blue,
          RightPixel.Color.Blue,
          self:MakeDistanceNoise(Distance),
          MaxValue
        )
    end

    return
      {
        Index = Index,
        Color = { Red = Red, Green = Green, Blue = Blue },
      }
  end

-- Exports:
return CalculateMidwayPixel

--[[
  2024-09-30
  2024-11-06
]]

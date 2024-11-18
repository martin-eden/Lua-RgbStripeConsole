-- Calculate midway pixel with noise

-- Last mod.: 2024-11-18

-- Imports:
local GetGap = request('Internals.GetGap')
local GetMiddle = request('Internals.GetMiddle')
local Clamp = request('Internals.Clamp')
local Floor = math.floor

--[[
  Given left and right pixels calculate midway pixel,
  adding distance-dependent noise.

  Type TPixel

    { Index: int, Color: { Red, Green, Blue: int } }

  Input

    LeftPixel, RightPixel: TPixel

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

    -- Calculate color components.
    local Color = { Red = 0, Green = 0, Blue = 0 }
    for Component in pairs(Color) do
      local Noise = self:MakeDistanceNoise(Distance)
      Noise = Noise * MaxValue
      Noise = Floor(Noise)

      local Value
      Value = GetMiddle(LeftPixel.Color[Component], RightPixel.Color[Component])
      Value = Value + Noise
      Value = Clamp(Value, 0, MaxValue)

      Color[Component] = Value
    end

    return { Index = Index, Color = Color }
  end

-- Exports:
return CalculateMidwayPixel

--[[
  2024-09-30
  2024-11-06
  2024-11-18
]]

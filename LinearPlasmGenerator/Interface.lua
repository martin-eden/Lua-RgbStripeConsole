-- Plasm generator interface

-- Last mod.: 2024-11-06

--[[
  Set-pixel handler for testing

  Needed for you to figure out argument format.
]]
local StockSetPixel =
  function(Pixel)
    print(
      string.format(
        '[%d] (%d %d %d)',
        Pixel.Index,
        Pixel.Color.Red,
        Pixel.Color.Green,
        Pixel.Color.Blue
      )
    )
  end

--[[
  Distance transforming function

  Try wilder functions that satisfy requirements!

  Input: [0.0, 1.0]
  Output: [0.0, 1.0]
]]
local DistanceIdentity =
  function(Distance)
    return Distance
  end

-- Exports:
return
  {
    -- [Config]

    -- Set-pixel callback
    SetPixel = StockSetPixel,

    -- Scaling factor
    Scale = 1.0,

    -- Distance scaling function [0.0, 1.0] -> [0.0, 1.0]
    TransformDistance = DistanceIdentity,

    -- Max color component value (case for power-limited LED stripes)
    MaxColorComponentValue = 80,

    -- [Main]

    -- Generate 1-D gradient
    Run = request('Run'),

    -- [Internal]

    -- Gap between leftmost and rightmost pixels. Calculated in Run()
    MaxGap = 1,

    -- Generate random color
    GetRandomColor = request('GetRandomColor'),

    -- Recursive filler for GetMidwayPixel()
    Plasm = request('Plasm'),

    -- Midway pixel calculator
    CalculateMidwayPixel = request('CalculateMidwayPixel'),

    -- Noise function [0.0, 1.0] -> [-1.0, 1.0]
    MakeDistanceNoise = request('MakeDistanceNoise'),
  }

--[[
  2024-09-30
  2024-11-06
]]

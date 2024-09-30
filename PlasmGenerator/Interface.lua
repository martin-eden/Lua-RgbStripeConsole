-- Plasm generator interface

--[[
  Algorithm turned to class.

  You'll need to provide your set-pixel function for practical use.
]]

-- Stock set-pixel handler for testing
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
  Get noise amplitude

  Try wilder functions that satisfy requirements!

  Input

    float [0.0, 1.0]

  Output

    float [0.0, 1.0]
]]
local StockNoiseAmp =
  function(Distance)
    return Distance
  end

-- Exports:
return
  {
    -- [Main] Generate 1-D gradient
    Generate = request('Generate'),

    -- [Tune] Your set-pixel callback
    SetPixel = StockSetPixel,

    -- [Tune] Scaling factor
    Scale = 1.0,

    -- [Tune] Distance noise amplitude function [0.0, 1.0]
    GetNoiseAmp = StockNoiseAmp,

    -- [Tune] Max color component value (case for power-limited LED stripes)
    MaxColorComponentValue = 80,

    -- [Inner] Gap between leftmost and rightmost pixels. Set in Generate()
    MaxGap = 1,

    -- [Inner] Generate random color
    GetRandomColor = request('GetRandomColor'),

    -- [Inner] Recursive filler for <GetMidwayPixel()>
    Plasm = request('Plasm'),

    -- [Inner] Calculate midway pixel
    GetMidwayPixel = request('GetMidwayPixel'),

    -- [Inner] Given distance [0.0, 1.0], return noise in range [-1.0, +1.0]
    MakeDistanceNoise = request('MakeDistanceNoise'),
  }

--[[
  2024-09-30
]]

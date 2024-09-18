-- Generate file with linear plasm data for LED stripe

--[[
  I'm just having fun! I'm tired of dull writing of nicely
  structured infrastructure.

  2024-09-18
]]

package.path = package.path .. ';../../?.lua'
require('workshop.base')

local Stripe = request('StripeWriter.Interface')
local Output = request('!.concepts.StreamIo.Output.File')

local OutputFileName = 'Data.Stripe'
Output:OpenFile(OutputFileName)

Stripe:Init(Output)

Stripe:Reset()

local StripeLength = 60

local LeftPixel =
  {
    Index = 0,
    Color = { Red = 64, Green = 64, Blue = 64 },
  }

local RightPixel =
  {
    Index = StripeLength - 1,
    Color = { Red = 64, Green = 64, Blue = 64 },
  }

-- Return some float in range [-1.0, +1.0]
local NoiseFunction =
  function(Distance)
    local SymmetricRandom = (math.random() * 2.0) - 1.0
    local Scale = 0.6
    return Scale * (Distance / StripeLength) * SymmetricRandom
  end

-- Calculate middle integer between two integers
local GetMiddle =
  function(Left, Right)
    return (Left + Right) // 2
  end

-- Clamp value for byte range [0, 255]
local ClampToByte =
  function(Value)
    if (Value < 0) then
      return 0
    end
    if (Value > 128) then
      return 128
    end
    Value = math.floor(Value)

    return Value
  end

-- Mix color component for two pixels at some distance
local MixColor =
  function(ColorA, ColorB, Noise)
    local Result

    Result = GetMiddle(ColorA, ColorB) + (Noise * 255)

    Result = ClampToByte(Result)

    --[[
    print(
      string.format(
        'MixColor(%d, %d, %.2f) = %d',
        ColorA,
        ColorB,
        Noise * 255,
        Result
      )
    )
    --]]

    return Result
  end

local GeneratePlasm
--[[
  Recursive function to generate "plasm":
  midway linear interpolation between pixels
  with some distance-dependent noise.

  It looks great for 2D, but I want to tinker with 1D version.
]]
GeneratePlasm =
  function(LeftPixel, RightPixel, MakeNoise)
    local Distance = (RightPixel.Index - LeftPixel.Index) - 1

    if (Distance <= 0) then
      return
    end

    local MidwayPixel =
      {
        Index = GetMiddle(LeftPixel.Index, RightPixel.Index),
        Color =
          {
            Red =
              MixColor(
                LeftPixel.Color.Red,
                RightPixel.Color.Red,
                MakeNoise(Distance)
              ),
            Green =
              MixColor(
                LeftPixel.Color.Green,
                RightPixel.Color.Green,
                MakeNoise(Distance)
              ),
            Blue =
              MixColor(
                LeftPixel.Color.Blue,
                RightPixel.Color.Blue,
                MakeNoise(Distance)
              ),
          },
      }

    Stripe:SetPixel(MidwayPixel)
    Stripe:Display()

    GeneratePlasm(LeftPixel, MidwayPixel, MakeNoise)
    GeneratePlasm(MidwayPixel, RightPixel, MakeNoise)
  end

Stripe:SetPixel(LeftPixel)
Stripe:SetPixel(RightPixel)
GeneratePlasm(LeftPixel, RightPixel, NoiseFunction)

Stripe:Display()

Output:CloseFile()

--[[
  2024-09-18
]]

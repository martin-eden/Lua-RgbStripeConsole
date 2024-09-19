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

-- Stripe length in pixels
local StripeLength = 60

--[[
  Max color component value

  I'm having USB interface brownout on my Arduino connected to
  keyboard (lol) when most of pixel color components are 255.
]]
local MaxColorValue = 80

-- Just return valid random color
local GetRandomColor =
  function()
    local Red = math.random(0, MaxColorValue)
    local Green = math.random(0, MaxColorValue)
    local Blue = math.random(0, MaxColorValue)
    return { Red = Red, Green = Green, Blue = Blue }
  end

local LeftPixel =
  {
    Index = 0,
    Color = GetRandomColor(),
  }

local RightPixel =
  {
    Index = StripeLength - 1,
    Color = GetRandomColor(),
  }

-- Roberto, can we have [-1, 1] random()?
local SymmetricRandom =
  function()
    return (math.random() * 2.0) - 1.0
  end

-- Static noise
local StaticNoise =
  function()
    return SymmetricRandom() * 0.05
  end

-- Linear noise
local LinearNoise =
  function(Distance)
    return Distance
  end

-- Quadratic noise
local QuadraticNoise =
  function(Distance)
    return Distance ^ 2
  end

-- Square root noise
local SqrtNoise =
  function(Distance)
    return Distance ^ 0.5
  end

-- Logarithmic noise
local LogNoise =
  function(Distance)
    return math.log(Distance, 2)
  end

-- Limit float value to given range
local Clamp =
  function(Value, MinValue, MaxValue)
    if (Value < MinValue) then
      return MinValue
    end
    if (Value > MaxValue) then
      return MaxValue
    end
    return Value
  end

-- Return some float in range [-1.0, +1.0]
local NoiseFunction =
  function(Distance)
    local DistanceNoiseFunc = LogNoise

    local DistanceNoise = DistanceNoiseFunc(Distance)
    local MaxDistanceNoise = DistanceNoiseFunc(StripeLength)

    local Scale = 5.0

    local Noise =
      Scale *
      (DistanceNoise / MaxDistanceNoise) *
      SymmetricRandom() +
      StaticNoise()

    Noise = Clamp(Noise, -1.0, 1.0)

    return Noise
  end

-- Calculate middle integer between two integers
local GetMiddle =
  function(Left, Right)
    return (Left + Right) // 2
  end

-- Clamp value for color range [0, MaxColorValue]
local ClampColorComponent =
  function(Value)
    if (Value < 0) then
      return 0
    end
    if (Value > MaxColorValue) then
      return MaxColorValue
    end
    Value = math.floor(Value)

    return Value
  end

-- Mix color component for two pixels at some distance
local MixColor =
  function(ColorA, ColorB, Noise)
    local Result

    -- Actually we're summing two color signals here:
    Result = GetMiddle(ColorA, ColorB) + (Noise * MaxColorValue)

    Result = ClampColorComponent(Result)

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

    -- print(string.format('Distance(%d) Noise(%.2f)', Distance, MakeNoise(Distance)))

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

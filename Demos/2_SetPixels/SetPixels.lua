-- [Example] Setting all stripe pixels

-- Last mod: 2025-11-12

--[[
  SetPixels(StartIndex, Colors)

  It gets list of colors and writes them from starting index.

  For this demo we need list of colors for full stripe length.
  We'll get em from [LinearPlasmGenerator].
]]

--[[
  Power strain

  Fully lighting 60 LEDs will yield to Arduino brownout.
  That's when LED stripe is powered from Arduino's 5V.
  That's why we recommend to use external power supply for stripe.

  This should not be the case for this code. We're dimming pixels.
  (But we're doing this for better appearance, not because of your
  setup limits.)

  In case of brownout stripe is garbled and serial connection to
  Arduino is lost. Disconnect 5V from stripe, reattach USB to Arduino
  and power up stripe again.
]]

local Config =
  {
    DeviceFileName = arg[1] or '/dev/ttyUSB0',

    -- Stripe length in pixels
    StripeLength = 60,
  }

package.path = package.path .. ';../../../../?.lua' .. ';../../?.lua'
require('workshop.base')

-- Imports:
local Stripe = request('StripeWriter.Interface')
local Output = request('!.concepts.StreamIo.Teletype.Interface')
local Gradient = request('!.concepts.Gradient.1d.Interface')
local GradientAlgo = request('!.concepts.Gradient.1d.Alternatives.CreateExecutionPlan.Bintree')
local GradientNoisyPixel = request('!.concepts.Gradient.1d.Alternatives.NoisyCreatePixel.Interface')

-- Generate colors to <Gradient.Line>
do
  Gradient.ColorFormat = 'Rgb'
  Gradient.LineLength = Config.StripeLength
  Gradient.CreateExecutionPlan = GradientAlgo

  GradientNoisyPixel.PixelsPerDistance = Config.StripeLength / 3
  Gradient.CreatePixel = GradientNoisyPixel:Generate_CreatePixel()

  GradientNoisyPixel.GetDistanceNoiseAmplitude =
    function(self, Distance)
      -- print('Distance', Distance)
      return Distance ^ 0.5
    end

  Gradient:Run()
end

-- local t2s = request('!.table.as_string')

-- Dim image (for better display on stripe)
do
  local DimFactor = 0.5
  local Image = Gradient.Line
  for X = 1, #Image do
    local Color = Image[X]
    Color[1] = Color[1] * DimFactor
    Color[2] = Color[2] * DimFactor
    Color[3] = Color[3] * DimFactor
  end
end

Output:Open(Config.DeviceFileName, 115200)

Stripe.Output = Output

Stripe:Reset()

Stripe:SetPixels(1, Gradient.Line)

Stripe:Display()

Output:Close()

--[[
  2024-09 # # #
  2024-11 #
  2024-12-24
  2025-11-12 Sync
]]

-- [Example] Setting all stripe pixels

-- Last mod: 2024-12-24

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
local Plasm = request('!.concepts.LinearPlasmGenerator.Interface')

-- Generate colors (in <Plasm.Image>)
do
  Plasm.ImageLength = Config.StripeLength
  Plasm.Scale = 6.0
  Plasm.TransformDistance =
    function(self, Distance)
      return Distance ^ 0.5
    end

  Plasm:Run()
end

-- Dim image (for better display on stripe)
do
  local DimFactor = 0.25
  local Image = Plasm.Image
  for X = 1, #Image do
    local Color = Image[X]
    Color.Red = Color.Red * DimFactor
    Color.Green = Color.Green * DimFactor
    Color.Blue = Color.Blue * DimFactor
  end
end

Output:Open(Config.DeviceFileName, 115200)

Stripe.Output = Output

Stripe:Reset()

Stripe:SetPixels(0, Plasm.Image)

Stripe:Display()

Output:Close()

--[[
  2024-09 # # #
  2024-11 #
  2024-12-24
]]

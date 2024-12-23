-- [Example] Setting LED stripe pixels

-- Last mod.: 2024-12-24

--[[
  Core functionality. Setting pixel colors

  This code sets several pixels of stripe.

  Data are sent to actual device.
]]

local Config =
  {
    DeviceName = arg[1] or '/dev/ttyUSB0',
  }

package.path = package.path .. ';../../../../?.lua' .. ';../../?.lua'
require('workshop.base')

-- Imports:
local Stripe = request('StripeWriter.Interface')
local Output = request('!.concepts.StreamIo.Teletype.Interface')
local Color = request('!.concepts.Image.Color.Interface')

-- Define colors
local Blue = new(Color, { Blue = 1.0 })
local Green = new(Color, { Green = 1.0 })
local Red = new(Color, { Red = 1.0 })

-- Open device
Output:Open(Config.DeviceName, 115200)

-- Connect device and driver
Stripe.Output = Output

-- Clear device memory
Stripe:Reset()

-- Set colors of some pixels
Stripe:SetPixel(12, Blue)
Stripe:SetPixel(30, Green)
Stripe:SetPixel(48, Red)

-- Display all pixels
Stripe:Display()

-- Close device
Output:Close()

--[[
  2024-09-18
  2024-12-24
]]

-- Generate file with linear plasm data for LED stripe

-- Last mod: 2024-11-11

--[[
  I'm just having fun! I'm tired of dull writing of nicely
  structured infrastructure.

  2024-09-18

  Rewritten using objectified plasm generator.
  Returned to dull writing of nicely structured infrastructure.

  2024-09-30
]]

package.path = package.path .. ';../../?.lua'
require('workshop.base')

-- Stripe length in pixels
local StripeLength = 60

--[[
  Brightness [0.0, 1.0]

  I'm having brownout on my Arduino connected to keyboard (lol)
  at full brightness.

  Also for dark time, high brightness looks ugly.
]]
local Brightness = 0.27

-- Name of file where we will write commands
local OutputFileName = 'Stripe commands.is'

-- Imports:
local Stripe = request('OptimizingStripeWriter.Interface')
local Output = request('!.concepts.StreamIo.Output.File')
local Plasm = request('LinearPlasmGenerator.Interface')

Output:Open(OutputFileName)

Stripe.Output = Output

Stripe:Reset()

do
  Plasm.MaxColorComponentValue = math.floor(Brightness * 0xFF)

  Plasm.SetPixel =
    function(Pixel)
      Stripe:SetPixel(Pixel)
      -- Stripe:Display()
    end

  Plasm.Scale = 6.0

  Plasm.TransformDistance =
    function(Distance)
      local Result
      --[[ Circle arc
      Result = (1 - (1 - Distance) ^ 2) ^ 0.5
      -- Circle arc ]]
      --[[ Full sine
      local Angle_Deg = Distance * 180 - 90
      local Angle_Rad = math.rad(Angle_Deg)
      Result = (math.sin(Angle_Rad) + 1) / 2
      -- Full sine ]]
      --[[ Upper half sine
      local Angle_Deg = Distance * 90
      local Angle_Rad = math.rad(Angle_Deg)
      Result = math.sin(Angle_Rad)
      -- Upper half sine ]]
      -- [[ Power of
      Result = Distance ^ 0.5
      -- Power of ]]
      return Result
    end

  Plasm:Run(0, StripeLength - 1)
end

Stripe:Display()

Output:Close()

--[[
  2024-09-18
  2024-09-25
  2024-09-30
  2024-11-11
]]

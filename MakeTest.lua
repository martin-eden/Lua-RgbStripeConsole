-- Generate file with test data for LED stripe

-- Last mod.: 2024-10-24

package.path = package.path .. ';../../?.lua'
require('workshop.base')

local OutputFileName = 'Stripe commands.is'

-- Imports:
local Stripe = request('StripeWriter.Interface')
local Output = request('!.concepts.StreamIo.Output.File')

Output:OpenFile(OutputFileName)

Stripe:Init(Output)

Stripe:Reset()

local Blue = { Red = 0, Green = 0, Blue = 255 }
local Green = { Red = 0, Green = 255, Blue = 0 }
local Red = { Red = 255, Green = 0, Blue = 0 }

Stripe:SetPixel({ Index = 12, Color = Blue })
Stripe:SetPixel({ Index = 30, Color = Green })
Stripe:SetPixel({ Index = 48, Color = Red })

Stripe:Display()

Output:CloseFile()

--[[
  2024-09-18
]]

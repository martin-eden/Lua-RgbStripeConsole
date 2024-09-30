-- Optimizing stripe writer

--[[
  .. or "Parasite Wrapper Over SetPixel()"

  We can set pixels in stripe by two functions.

  One is SetPixel() that sets individual pixel. It requires 5 tokens
  to transfer.

  Another is SetPixels() that sets stride of pixels to list of colors.
  It requires (3 * N + 2) tokens.

  So if we're optimizing transfer time, we want to use SetPixels()
  when setting two or more adjacent pixels.

  But SetPixels() is not so convenient. And my use case is algorithm
  that sets pixels in non-sequential way. (I'm looking at you,
  [PlasmGenerator]!)

  So idea of this class is provide fake SetPixel() that just sets
  pixel in our memory without emitting command to RGB stripe.

  At Display() we are scanning our memory, getting list of strides
  and send each stride using SetPixels().
]]

-- [Maintenance] Stripe writer we're actually using
local StockStripeWriter = request('^.StripeWriter.Interface')

local Clone = request('!.table.clone')
local MergeInto = request('!.table.merge')

local Parasite =
  {
    Init = request('Init'),
    SetPixel = request('SetPixel'),
    Display = request('Display'),

    -- [Maintenance] Stripe writer we're using
    StripeWriter = StockStripeWriter,
    -- [Maintenance] We'll cache pixels here
    Pixels = {},
    -- [Maintenance] Min index we've encountered
    MinIndex = 0,
    -- [Maintenance] Max index we've encountered
    MaxIndex = 0,
  }

local Interface = Clone(StockStripeWriter)

MergeInto(Interface, Parasite)

-- Exports:
return Interface

--[[
  2024-09-30
]]

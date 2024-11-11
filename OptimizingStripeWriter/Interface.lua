-- Optimizing stripe writer

--[[
  .. or "Parasite Wrapper Over SetPixel()"

  We can set pixels in stripe by two functions.

  One is SetPixel() that sets individual pixel. It requires 5 tokens
  to transfer.

  Another is SetPixels() that sets stride of pixels to list of colors.
  It requires (3 * N + 2) tokens.

  We're optimizing transfer time so we want to use SetPixels()
  when setting two or more adjacent pixels.

  But my use case is algorithm that sets pixels in non-sequential way.
  (I'm looking at you, [PlasmGenerator]!)

  So idea is provide fake SetPixel() that just sets pixel in our memory
  without emitting command to RGB stripe.

  At Display() time we are scanning our memory, getting list of strides
  and send each stride using SetPixels().
]]

-- Stripe writer we're actually using
local StockStripeWriter = request('^.StripeWriter.Interface')

local Clone = request('!.table.clone')
local ForceMerge = request('!.table.merge_and_patch')

local Parasite =
  {
    -- [Config] Output implementer
    Output = Output,

    -- [Overridden methods]
    SetPixel = request('SetPixel'),
    SetPixels = request('SetPixels'),
    Display = request('Display'),

    -- [Internals]
    -- Stripe writer we're using
    StripeWriter = StockStripeWriter,
    -- We'll cache pixels here
    Pixels = {},
    -- Min index we've encountered
    MinIndex = 0,
    -- Max index we've encountered
    MaxIndex = 0,
  }

local Interface = Clone(StockStripeWriter)

ForceMerge(Interface, Parasite)

-- Exports:
return Interface

--[[
  2024-09-30
  2024-11-11
]]

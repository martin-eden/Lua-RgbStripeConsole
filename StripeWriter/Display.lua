-- Display pixels

-- Last mod.: 2024-12-23

--[[
  Display pixels on LED stripe
]]
local Display =
  function(self)
    self:WriteCommand('D')

    --[[
      Display speed is near 500 meters per second (0.5 m per ms).

      Our firmware runs on ATmega328/P. It has 2048 bytes of memory.
      1 meter is 60 pixels. 1 pixel is 3 bytes. So there is no memory
      for stripes longer than 11 meters (2048 / 180).

      22 ms is practical ceil.
    ]]

    -- Our current setup is 1 m stripe
    local DisplayDuration_Ms = 2

    self:Delay_Ms(DisplayDuration_Ms)
  end

-- Exports:
return Display

--[[
  2024-09-18
  2024-10-24
  2024-10-29
  2024-12-23
]]

-- Write command to send pixels to LED stripe

-- Last mod.: 2024-10-29

return
  function(self)
    self:WriteItem('D')

    --[[
      Display speed is near 0.5 ms per meter (500 meters per second).
      Let's assume 1 ms per meter for safety.

      Our firmware runs on ATmega328/P. 2048 bytes of memory.
      1 meter is 60 pixels. 1 pixel is 3 bytes.

      So there is no memory for stripes longer than 11 meters.

      11 ms is practical ceil
    ]]

    -- Our current setup is 1 m stripe
    local DisplayDuration_Ms = 1

    self:MakeDelay_Ms(DisplayDuration_Ms)
  end

--[[
  2024-09-18
  2024-10-24
  2024-10-29
]]

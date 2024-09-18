-- RGB stripe output interface wrapper

return
  {
    -- Set output implementer
    Init = request('Init'),
    -- Reset: makes pixels black
    Reset = request('Reset'),
    -- Display: send pixels to LED stripe
    Display = request('Display'),
    -- Set pixel. Format { Index = int, Color = { Red = int, Green = int, Blue = int } }
    SetPixel = request('SetPixel'),

    -- Maintenance: output implementer
    Output = nil,
    -- Handy: print string as line
    WriteLine = request('WriteLine'),
  }

--[[
  2024-09-18
]]

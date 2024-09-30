-- RGB stripe output interface wrapper

--[[
  RGB stripe commands emitter

  Methods emitting command string to <.Output> writer.

  If arguments are needed for method, they are passed in one table.

  Input verification

    Our output must satisfy other side interface requirements.
    Basically it means that index should be in [0, 0xFFFF] and
    color component in [0, 0xFF].

    If it is not so, we explode with error.
]]

--[[
  TColor - structure used exclusively for documentation

  Just a table with three named color components:

  {
    Red: byte
    Green: byte
    Blue: byte
  }
]]

local Interface =
  {
    -- Maintenance: Set output implementer
    Init = request('Init'),

    -- Reset: makes pixels black
    Reset = request('Reset'),
    -- Display: send pixels to LED stripe
    Display = request('Display'),
    -- Set pixel. Format { Index = word, Color = TColor }
    SetPixel = request('SetPixel'),
    -- Set pixels in range. Format { StartIndex = word, StopIndex = word, Colors = { TColor .. } }
    SetPixels = request('SetPixels'),

    -- Maintenance: output implementer
    Output = nil,
    -- Handy: print string as line
    WriteLine = request('WriteLine'),
  }

return Interface

--[[
  2024-09-18
  2024-09-30
]]

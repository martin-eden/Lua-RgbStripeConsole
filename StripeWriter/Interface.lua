-- RGB stripe output interface wrapper

-- Last mod.: 2024-10-24

--[[
  RGB stripe commands emitter

  Methods emitting strings to <.Output> writer.

  If arguments are needed for method, they are passed in one table.
]]

--[[
  We're emitting in "Itness" (or "Listness"?) format.

  It means that command "D" to update LED stripe is written as
  "( D )". This allows us to split long commands (like "set pixels")
  to multiple lines for readability.

  File sender (in "SendData.lua") will parse those lines back
  to commands and will send commands.

  This way we can insert small pause between sending commands,
  not between sending lines.
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

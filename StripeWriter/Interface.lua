-- RGB stripe output interface wrapper

-- Last mod.: 2024-10-25

--[[
  RGB stripe commands emitter

  Methods emitting strings to <.Output> writer.

  If arguments are needed for method, they are passed in one table.
]]

--[[
  We're emitting in "Itness" (or "Listness"?) format.

  It means that command "D" to update LED stripe is written as
  "( D )".

  This allows us to represent long commands (like "set pixels") in
  multiple lines for readability. This allows sending several
  commands in one packet later.

  This blocks ability to use device file as output. Because we will
  send "( D )" instead of "D ".

  This formatting occurs in WriteItem(). By overriding that method
  it's possible to send device commands to device, not to file.
  If we really want to.
]]

--[[
  TColor - structure used exclusively for documentation

  Just a table with three named color components:

    { Red: byte, Green: byte, Blue: byte }
]]

local Interface =
  {
    -- [Config] Set output implementer
    Init = request('Init'),

    -- [Commands]

    -- Reset: makes pixels black
    Reset = request('Reset'),

    -- Display: send pixels to LED stripe
    Display = request('Display'),

    -- Set pixel. Format is { Index = word, Color = TColor }
    SetPixel = request('SetPixel'),

    --[[
      Set pixels in range. Format is
      { StartIndex = word, StopIndex = word, Colors = { TColor .. } }
    ]]
    SetPixels = request('SetPixels'),

    -- [/Commands]

    -- [Internal] Output implementer
    Output = nil,

    -- [Internal] Write string as an item
    WriteItem = request('WriteItem'),
  }

return Interface

--[[
  2024-09-18
  2024-09-30
  2024-10-25
]]

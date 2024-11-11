-- RGB stripe commands emitter

-- Last mod.: 2024-11-11

--[[
  We're emitting in "Itness" (or "Listness"?) format.

  It means that command "D" to update LED stripe is written as
  "( D )".

  This allows us to represent long commands (like "set pixels") in
  multiple lines for readability.

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
    -- [Config] Output stream
    Output = nil,

    -- [Main]

    -- Make pixels black
    Reset = request('Reset'),

    -- Display pixels on LED stripe
    Display = request('Display'),

    -- Set pixel
    SetPixel = request('SetPixel'),

    -- Set pixels in range
    SetPixels = request('SetPixels'),

    -- [Internal]

    -- Delay command text
    DelayCommand = 'DelayMs',

    -- Write command to make delay in milliseconds
    MakeDelay_Ms = request('MakeDelay_Ms'),

    -- Write string as item in Itness format
    WriteItem = request('WriteItem'),
  }

return Interface

--[[
  2024-09-18
  2024-09-30
  2024-10-25
  2024-11-11
]]

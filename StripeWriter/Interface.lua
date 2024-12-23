-- RGB stripe commands emitter

-- Last mod.: 2024-12-23

--[[
  We're emitting commands in device format

  Basically it means that we're just crafting and writing strings.

  Device uses text protocol. Items are printable ASCII strings without
  spaces. Items delimiter is space or newline.

  Device finishes parsing command when it had read all required items.
  Item is read when we saw delimiter or timeout expired.
  So we're adding tail delimiter to avoid spending time on timeout.

  For example "D" is "display pixels" command. We're sending it as
  "D " (or as "D<newline>").
]]

--[[
  Delays

  For not entirely clear reasons commands need time delays between
  them. So we're sleeping some time between commands.

  Repurposing this module for writing to file you should keep
  delay information. Perhaps as command for file interpreter.
]]

--[[
  Supported commands subset

  Device has more commands. It can send us pixel color.
  It can manage stripe length. It can manage output pin.

  We're supporting commands for just setting colors and display.

  ( Yes, of course I can provide here interface for all commands.
    I wrote that firmware myself. But it's creeping featurism. )
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

    -- Set pixel: index, color
    SetPixel = request('SetPixel'),

    -- Set segment of pixels: index, colors
    SetPixels = request('SetPixels'),

    -- [Internal]

    -- Delay for given amount of milliseconds
    Delay_Ms = request('Delay_Ms'),

    -- Write string as command
    WriteCommand = request('WriteCommand'),
  }

return Interface

--[[
  2024-09 # #
  2024-10 #
  2024-11 #
  2024-12-23
]]

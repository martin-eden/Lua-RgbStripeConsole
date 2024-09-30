-- Unpack color record to sequence of three components

local IsByte = request('!.number.is_byte')

--[[
  Unpack color record

  Input

    {
      Red: byte
      Green: byte
      Blue: byte
    }

  Output

    Red, Green, Blue

  Errors policy

    Explode
]]
local UnpackColor =
  function(Color)
    assert_table(Color)

    local Red = Color.Red
    local Green = Color.Green
    local Blue = Color.Blue

    assert(IsByte(Red))
    assert(IsByte(Green))
    assert(IsByte(Blue))

    return Red, Green, Blue
  end

-- Exports:
return UnpackColor

--[[
  2024-09-30
]]

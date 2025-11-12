-- Unpack color record

-- Last mod.: 2025-11-12

local DenormalizeColor = request('!.concepts.Image.Color.Denormalize')

--[[
  Unpack color record to sequence of three byte components

  Input

    Color format that is used by [Image.Color].
    Currently it's three floats (red, green, blue) in [0.0, 1.0].

  Output

    Sequence of three color components in byte range [0, 255].
]]
local UnpackColor =
  function(Color)
    local ByteColor = new(Color)

    DenormalizeColor(ByteColor)

    return ByteColor[1], ByteColor[2], ByteColor[3]
  end

-- Exports:
return UnpackColor

--[[
  2024-09-30
  2024-12-24
]]

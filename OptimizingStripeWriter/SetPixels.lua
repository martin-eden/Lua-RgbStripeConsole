-- Set range of pixels

-- Last mod.: 2024-11-11

local SetPixels =
  function(self, Arg)
    local StartIndex = Arg.StartIndex
    local StopIndex = Arg.StopIndex
    local Pixels = Arg.Colors

    for Index = StartIndex, StopIndex do
      self:SetPixel({ Index = Index, Color = Pixels[Index] })
    end
  end

-- Exports:
return SetPixels

--[[
  2024-11-11
]]

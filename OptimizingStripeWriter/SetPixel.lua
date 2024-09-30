-- SetPixel() wrapper. Pixel is cached until Display()

--[[
  Personal reminder, Pixel format is

    { Index: uint, Color: { Red, Green, Blue: byte } }
]]
return
  function(self, Pixel)
    self.Pixels[Pixel.Index] = Pixel.Color

    self.MinIndex = math.min(self.MinIndex, Pixel.Index)
    self.MaxIndex = math.max(self.MaxIndex, Pixel.Index)
  end

--[[
  2024-09-30
]]

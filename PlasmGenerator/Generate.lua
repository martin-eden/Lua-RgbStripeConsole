-- Plasm generator wrapper

local GetGap = request('Internals.GetGap')

--[[
  Given pixels range, set border pixels to random values and
  implement "plasm" gradient filling.

  Also set <.MaxNoiseAmp> before calculations.

  Input

    StartIndex: int
    StopIndex: int
    self: table
      GetRandomColor()
      SetPixel()
      Plasm()

  Output

    By <self.Plasm()>
]]
return
  function(self, StartIndex, StopIndex)
    local LeftPixel =
      { Index = StartIndex, Color = self:GetRandomColor() }

    self.SetPixel(LeftPixel)

    local RightPixel =
      { Index = StopIndex, Color = self:GetRandomColor() }

    self.SetPixel(RightPixel)

    self.MaxGap = GetGap(LeftPixel.Index, RightPixel.Index)

    self:Plasm(LeftPixel, RightPixel)
  end

--[[
  2024-09-18
  2024-09-25
  2024-09-30
]]

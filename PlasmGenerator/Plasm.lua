-- 1-D "plasm" gradient generation core

local GetGap = request('Internals.GetGap')

--[[
  Generate "1-D plasm": midway linear interpolation between pixels with
  some distance-dependent noise.

  Input

    LeftPixel, RightPixel: TPixel
      {
        Index: int
        Color:
          {
            Red, Green, Blue: int
          }
      }

    self: table -- parameters and helpers

      Plasm() -- this function
      GetMidwayPixel: (function(self, TPixel, TPixel): TPixel)
        -- actual calculation
      SetPixel() -- set pixel implementation

  Output

    Call <self.SetPixel()>
]]
return
  function(self, LeftPixel, RightPixel)
    local Gap = GetGap(LeftPixel.Index, RightPixel.Index)

    if (Gap <= 0) then
      return
    end

    local MidwayPixel = self:CalculateMidwayPixel(LeftPixel, RightPixel)

    -- Calling external handler, so "self.", not "self:"
    self.SetPixel(MidwayPixel)

    self:Plasm(LeftPixel, MidwayPixel)
    self:Plasm(MidwayPixel, RightPixel)
  end

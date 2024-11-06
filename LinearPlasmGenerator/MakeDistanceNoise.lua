-- Distance noise calculation

-- Last mod.: 2024-11-06

local SymmetricRandom = request('Internals.SymmetricRandom')
local Clamp = request('Internals.Clamp')

return
  function(self, Distance)
    Distance = Clamp(self.Scale * Distance, 0.0, 1.0)

    local Noise = self.TransformDistance(Distance) * SymmetricRandom()

    Noise = Clamp(Noise, -1.0, 1.0)

    return Noise
  end

--[[
  2024-09-30
  2024-11-06
]]

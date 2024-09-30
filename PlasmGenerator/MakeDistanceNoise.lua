-- Core. Distance noise calculation

local SymmetricRandom = request('Internals.SymmetricRandom')
local Clamp = request('Internals.Clamp')

--[[
  Given distance, return noise

  Input

    Distance: float [0.0, 1.0]

    self
      Scale
      GetNoiseAmp

  Output

    float: [-1.0, +1.0] -- random noise value, considering distance and
      settings
]]
return
  function(self, Distance)
    Distance = Clamp(self.Scale * Distance, 0.0, 1.0)

    local Noise = self.GetNoiseAmp(Distance) * SymmetricRandom()

    Noise = Clamp(Noise, -1.0, 1.0)

    return Noise
  end

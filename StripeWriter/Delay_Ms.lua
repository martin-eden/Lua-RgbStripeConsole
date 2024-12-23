-- Sleep for given amount of milliseconds

-- Last mod.: 2024-12-23

-- Imports:
local SleepSec = request('!.system.sleep')

-- Exports:
return
  function(self, Delay_Ms)
    assert_integer(Delay_Ms)
    assert(Delay_Ms >= 0)

    SleepSec(Delay_Ms / 1000)
  end

--[[
  2024-10-29
  2024-12-23
]]

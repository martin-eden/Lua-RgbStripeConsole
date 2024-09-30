-- Set output implementer

local OutputBase = request('!.concepts.StreamIo.Output')
local AssertIs = request('!.concepts.Class.AssertIs')

return
  function(self, Output)
    AssertIs(Output, OutputBase)

    self.Output = Output
  end

--[[
  2024-09-18
]]

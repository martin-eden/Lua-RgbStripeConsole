-- Set output implementer

--[[
  We have to set output for our stock stripe writer.
  Also we are clone of it, so let's call it for us too.
  Mad design.
]]
return
  function(self, Output)
    self.StripeWriter:Init(Output)
    self.StripeWriter.Init(self, Output)
  end

--[[
  2024-09-30
]]

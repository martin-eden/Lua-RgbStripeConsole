-- Set output implementer

-- Last mod.: 2024-10-25

--[[
  WHY?!

    return
      function(self, Output)
        self.Output = Output
      end

    Why not just set .Output to what we want in outer code?!

    Because Init() is a function. So it may be called from another
    function.

    Example

      [OptimizingStripeWriter] clones our interface and rides on us.

        OptimizingStripeWriter
          .StripeWriter
            .Output
          .Output

      It's Init() sets both <Output>'s. So outer code only cares
      about calling Init().

      Without Init() outer code should know internals of specific
      implementer and in set two fields.
]]

return
  function(self, Output)
    self.Output = Output
  end

--[[
  2024-09-18
  2024-10-25
]]

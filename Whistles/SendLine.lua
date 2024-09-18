-- Send line to output with terminal printing

local PrintLine =
  function(self, Line, Output)
    local OutputFormat =
      '< (%s)'

    local OutputLine =
      string.format(OutputFormat, Line)

    print(OutputLine)

    Output:Write(Line)
    Output:Write('\n')
  end

-- Exports:
return PrintLine

--[[
  2024-09-18
]]

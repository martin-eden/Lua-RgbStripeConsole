-- Send line to output with terminal printing

local SleepSec = request('!.system.sleep')

-- Send line to output (usually UART device) with some delay
local PrintLine =
  function(self, Line, Output)
    --[[ Local echo
    local OutputFormat =
      '< (%s)'

    local OutputLine =
      string.format(OutputFormat, Line)

    print(OutputLine)
    -- Local echo ]]

    Output:Write(Line)
    Output:Write('\n')

    local LineDelaySec = .05
    SleepSec(LineDelaySec)
  end

-- Exports:
return PrintLine

--[[
  2024-09-18
]]

-- Read line from file handle with stdout echo

--[[
  Read line from file handle with echo for human.

  If there are no line, return nil.
]]
local ReadLine =
  function(self, InputFileHandle)
    local Line = InputFileHandle:read('l')

    -- That's dumb, I know
    if is_nil(Line) then
      return nil
    end

    local PrintLineFormat =
      '> (%s)'

    print(string.format(PrintLineFormat, Line))

    return Line
  end

-- Exports:
return ReadLine

--[[
  2024-09-18
]]

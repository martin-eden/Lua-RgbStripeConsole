-- [Internal] Wrap string as item and send to <.Output>

-- Imports:
local Trim = request('!.string.trim')
local StringToLines = request('!.string.to_lines')

local ProcessOneLine =
  function(Line, Output)
    Line = Trim(Line)
    Output:Write('( ')
    Output:Write(Line)
    Output:Write(' )\n')
  end

local ProcessMultipleLines =
  function(Lines, Output)
    Output:Write('(\n')

    for Index, Line in ipairs(Lines) do
      Output:Write('  ')
      Output:Write(Line)
      Output:Write('\n')
    end

    Output:Write(')\n')
  end

--[[
  Wrap string in ( ) for Itness and write to output

  We're trying to be nice for multiline strings,
  splitting them to lines and indenting.
]]
local WriteItem =
  function(self, String)
    local Lines = StringToLines(String)
    if (#Lines == 1) then
      ProcessOneLine(Lines[1], self.Output)
    else
      ProcessMultipleLines(Lines, self.Output)
    end
  end

-- Exports:
return WriteItem

--[[
  2024-09-18
  2024-09-30
  2024-10-25
]]

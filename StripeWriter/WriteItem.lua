-- [Internal] Wrap string as item and send to <.Output>

-- Last mod.: 2024-10-31

-- Imports:
local Trim = request('!.string.trim')
local Lines = request('!.concepts.Lines.Interface')

local ProcessOneLine =
  function(String, Output)
    String = Trim(String)

    Output:Write('( ')
    Output:Write(String)
    Output:Write(' )\n')
  end

local ProcessMultipleLines =
  function(InputLines, Output)
    local OutputLines = new(InputLines)

    OutputLines:Indent()

    OutputLines:AddFirstLine('(')
    OutputLines:AddLastLine(')')

    Output:Write(OutputLines:ToString())
  end

--[[
  Wrap string in ( ) for Itness and write to output

  We're trying to be nice for multiline strings,
  splitting them to lines and indenting.
]]
local WriteItem =
  function(self, String)
    local Lines = new(Lines)
    Lines:FromString(String)
    if Lines:IsOneLine() then
      ProcessOneLine(Lines:GetFirstLine(), self.Output)
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
  2024-10-31
]]

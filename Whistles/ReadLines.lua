-- Read lines from input

--[[
  Read lines from input and return them as table sequence

  For the sake of first implementation I'm using file handle,
  not [StreamIo.Input]. Because Lua's file handle have "lines" method
  while [Input] doesn't. (And probably shouldn't. There should be
  something of higher order for this. Like [StreamIo.Lines.Input].)
]]
local ReadLines =
  function(self, FileHandle)
    local Lines = {}
    for Line in FileHandle:lines() do
      table.insert(Lines, Line)
    end

    -- Just some pretty-printing with tracking longest line index length
    do
      local NumDigitsAtMaxIndex
      NumDigitsAtMaxIndex = #tostring(#Lines)

      --[[
        Alternative

          string.format('%%0%dd', NumDigitsAtMaxIndex)

        is a lot worse.
      ]]
      local LineNumFormat =
        '%0' .. NumDigitsAtMaxIndex .. 'd'

      local FullLineFormat =
        '> [' .. LineNumFormat .. '] %s'

      for Index, Line in ipairs(Lines) do
        print(string.format(FullLineFormat, Index, Line))
      end
    end

    return Lines
  end

-- Exports:
return ReadLines

--[[
  2024-09-18
]]

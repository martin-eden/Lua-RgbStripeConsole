-- Send list of string/list items

-- Last mod.: 2024-10-24

--[[
  We're making delay after sending each item.

  Items can be folded (f.e. { 'SPR', '0', '0', { '255', '0', '0' } }).
  We're pausing for small time after sending each item (two pauses
  for that example).
]]

local DelaySec = 0.05

local SleepSec = request('!.system.sleep')

local SendItems =
  function(self, Node, Output)
    --[[
      Item can be a string or table with list of items.
    ]]

    if is_string(Node) then
      Output:Write(Node)
      Output:Write(' ')
      return
    end

    assert_table(Node)

    for Index, Item in ipairs(Node) do
      self:SendItems(Item, Output)
    end

    --[[ Debug output
    if is_string(Node[1]) then
      print('>', table.concat(Node, '|'))
    end
    --]]

    SleepSec(DelaySec)
  end

-- Exports:
return SendItems

--[[
  2024-10-24
]]

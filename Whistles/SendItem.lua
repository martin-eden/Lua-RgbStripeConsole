-- Send list of string/list items

-- Last mod.: 2024-11-11

--[[
  Regarding delays

  Current version of firmware processes most commands faster than
  they are sent.

  Exceptions are commands "T" (display test pattern) and "D"
  (display data). They are sending data to stripe so it takes some
  time. Proportional to stripe length (~ 0.5 ms per 1 meter of stripe).

  However we still need delay between commands. 1 ms is quite enough.
  It's needed for firmware to go awaiting for next command.
  So we're adding 1 ms delay between items.

  Also we do support additional command for us: DelayMs.

  In stream it looks like

    { ..., 'DelayMs', '1', ... }

  Aha! Delay for 1 ms. We're consuming those two items and making delay.
]]

-- Imports:
local SleepSec = request('!.system.sleep')

local InteritemDelay_Ms = 1

local SendItem =
  function(self, Node)
    -- Node can be a string or table with list of nodes.

    if is_string(Node) then
      self.Output:Write(Node)
      self.Output:Write(' ')
      return
    end

    assert_table(Node)

    for Index, Item in ipairs(Node) do
      -- Is "delay" processing command?
      if is_string(Item) and (Item == 'DelayMs') then
        -- Consume ("DelayMs", str) pair and make delay
        -- Advance index
        Index = Index + 1
        -- Consume next item
        if not is_string(Node[Index]) then
          -- Bad command, recede index
          Index = Index - 1
        else
          local DelayMs
          local Value
          Value = Node[Index]
          Value = tonumber(Value)
          if is_integer(Value) then
            DelayMs = Value
          end
          if DelayMs then
            SleepSec(DelayMs / 1000)
          end
        end
      -- Ordinary item
      else
        self:SendItem(Item)
      end
    end

    SleepSec(InteritemDelay_Ms / 1000)
  end

-- Exports:
return SendItem

--[[
  2024-10-24
  2024-10-29
  2024-11-11
]]

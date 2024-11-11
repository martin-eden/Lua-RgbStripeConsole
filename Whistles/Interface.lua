-- Bells and whistles for teletype

-- Last mod.: 2024-11-11

--[[
  I want to see what is read and what is written.
  Also I want send-file functionality.

  It should be moved somewhere in future but for now it
  should be born.
]]

return
  {
    -- [Config]

    -- Input interface implementer
    Input = nil,

    -- Output interface implementer
    Output = nil,

    ReadLine = request('ReadLine'),
    ReadLines = request('ReadLines'),

    SendItem = request('SendItem'),
    SendFile = request('SendFile'),
  }

--[[
  2024-09-18
  2024-10-24
  2024-11-11
]]

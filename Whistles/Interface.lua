-- Bells and whistles for teletype

-- Last mod.: 2024-10-29

--[[
  I want to see what is read and what is written.
  Also I want send-file functionality.

  It should be moved somewhere in future but for now it
  should be born.
]]

return
  {
    ReadLine = request('ReadLine'),
    ReadLines = request('ReadLines'),

    SendItem = request('SendItem'),
    SendFile = request('SendFile'),
  }

--[[
  2024-09-18
  2024-10-24
]]

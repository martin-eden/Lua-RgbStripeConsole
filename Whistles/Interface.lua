-- Bells and whistles for teletype

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

    SendLine = request('SendLine'),
    SendLines = request('SendLines'),
    SendFile = request('SendFile'),
  }

--[[
  2024-09-18
]]

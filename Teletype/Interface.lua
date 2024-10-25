-- File interface for UART devices

-- Last mod.: 2024-10-25

--[[
  Problem

    My use case is Arduino at "/dev/ttyUSB0".

    With some "stty" fiddling, I can open it for reading or for
    writing as file. Problem is that I'm doing conversations, so
    need both reading and writing. So I'm opening it under two
    different file handles pointing to the same device.

    It works, but it's ugly. Besides, closing second handle resets
    Arduino which annoys me much. (I'm writing data to LED stripe,
    so reset blanks stripe.)

  Solution

    This design exports two functions: open and close.
    And supports two interfaces [StreamIo.Input] and [StreamIo.Output].

    "Open" opens device both for reading and writing and sets file handle.
    "Close" closes device and zeroes file handle.

    I still need "stty" magic and want it be reversible. So this class
    has a state which is string with port configuration.
]]

-- Exports:
return
  {
    -- [New] Open UART device by name
    Open = request('Open'),
    -- [New] Close UART device
    Close = request('Close'),

    -- [Interface]: [StreamIo.Input]
    Read = request('Read'),
    -- [Interface]: [StreamIo.Output]
    Write = request('Write'),

    -- [Internals]
    IsConnected = false,
    PortName = nil,
    FileHandle = nil,
    OriginalPortParams = nil,
    BorrowedFileInput = request('^.StreamIo.Input.BorrowedFile'),
    BorrowedFileOutput = request('^.StreamIo.Output.BorrowedFile'),
  }

--[[
  2024-09-18
]]

-- Close UART device opened for reading and writing

local GetPortParams = request('!.mechs.tty.get_port_params')
local SetPortParams = request('!.mechs.tty.set_port_params')

--[[
  Close our device and zero internal state.
]]
local Disconnect =
  function(self)
    if not self.IsConnected then
      return
    end

    io.close(self.FileHandle)
    self.FileHandle = nil

    self.BorrowedFileInput.FileHandle = nil
    self.BorrowedFileOutput.FileHandle = nil

    local CurrentPortParams = GetPortParams(self.PortName)
    if (CurrentPortParams == self.OriginalPortParams) then
      print('Read. Params are same, no need for SetPortParams().')
    else
      print('Read. Restoring original port params.')
      SetPortParams(self.PortName, self.OriginalPortParams)
    end
    self.OriginalPortParams = nil

    self.PortName = nil

    self.IsConnected = false

    print(string.format('Device is closed.'))
  end

-- Exports:
return Disconnect

--[[
  2024-09-18
]]

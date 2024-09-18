-- Open UART device by name

local FileExists = request('!.file_system.file.exists')
local GetPortParams = request('!.mechs.tty.get_port_params')
local SetNonBlockingRead = request('!.mechs.tty.set_non_blocking_read')
local SleepSec = request('!.system.sleep')

--[[
  Open port both for reading and writing.

  In case of errors explodes.
]]
local ConnectTo =
  function(self, PortName)
    assert_string(PortName)

    if not FileExists(PortName) then
      error(string.format("Can't see device '%s'.", PortName))
    end

    self.PortName = PortName

    if self.IsConnected then
      self:Close()
    end

    self.OriginalPortParams = GetPortParams(PortName)

    local Baud = 57600
    local ReadTimeoutSec = 0.5
    SetNonBlockingRead(PortName, ReadTimeoutSec, Baud)

    self.FileHandle = io.open(PortName, 'r+')

    self.BorrowedFileInput.FileHandle = self.FileHandle
    self.BorrowedFileOutput.FileHandle = self.FileHandle

    self.IsConnected = true

    local WarmupDelaySec = 3.5
    SleepSec(WarmupDelaySec)

    print(
      string.format(
        'Device "%s" is opened for reading and writing.',
        self.PortName
      )
    )
  end

-- Exports:
return ConnectTo

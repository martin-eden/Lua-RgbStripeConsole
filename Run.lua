package.path = package.path .. ';../../?.lua'
require('workshop.base')

local Teletype = request('Teletype.Interface')
local Stripe = request('StripeIo.Interface')

local SleepSec = request('!.system.sleep')

local PortName = '/dev/ttyUSB0'

Teletype:Open(PortName)

local WarmupDelaySec = 3.5
SleepSec(WarmupDelaySec)

--[[
while true do
  local MaxChunkLen = 400
  local InterchunkDelaySec = 0.1

  local GotSomething, IsComplete = Teletype:Read(MaxChunkLen)

  if (GotSomething == '') then
    break
  end

  print(string.format('[%s]', GotSomething))

  if not IsComplete then
    SleepSec(InterchunkDelaySec)
  end
end
--]]

local LineNumber = 0
for Line in Teletype.FileHandle:lines() do
  LineNumber = LineNumber + 1
  print(string.format('> [%02d] %s', LineNumber, Line))
end

local Lines =
  {
    'R',
    'SP 12 0 0 255',
    'SP 30 0 255 0',
    'SP 48 255 0 0',
    'D',
  }

Stripe:SendLines(Lines, Teletype)

SleepSec(1);

-- Teletype:Close()

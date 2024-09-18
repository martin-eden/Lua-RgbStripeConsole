package.path = package.path .. ';../../?.lua'
require('workshop.base')

local Teletype = request('Teletype.Interface')
local Stripe = request('StripeIo.Interface')
local Whistles = request('Whistles.Interface')

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

Whistles:ReadLines(Teletype.FileHandle)

local DataFileName = 'Data.Stripe'

Whistles:SendFile(DataFileName, Teletype)

SleepSec(1);

-- Teletype:Close()

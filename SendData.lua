-- Send "Stripe commands.is" contents to UART

-- Last mod.: 2024-11-11

local Config =
  {
    DataFileName = 'Stripe commands.is',
    PortName = '/dev/ttyUSB0',
    PortSpeed = 115200,
  }

package.path = package.path .. ';../../?.lua'
require('workshop.base')

-- Imports:
local Teletype = request('!.concepts.StreamIo.Teletype.Interface')
local Whistles = request('Whistles.Interface')

-- Open UART
Teletype:Open(Config.PortName, Config.PortSpeed)

-- Read and echo initial greeting
Whistles:ReadLines(Teletype)

-- Send items
Whistles:SendFile(Config.DataFileName, Teletype)

Teletype:Close()

--[[
  2024-09-18
  2024-10-24
  2024-11-11
]]
